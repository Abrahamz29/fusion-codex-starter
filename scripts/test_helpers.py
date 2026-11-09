"""Black-box checks for Windows helpers; no real CAD or user configuration changes."""
import json
import os
from pathlib import Path
import shutil
import subprocess
import tempfile
import threading
import unittest
from http.server import BaseHTTPRequestHandler, ThreadingHTTPServer

ROOT = Path(__file__).resolve().parents[1]
SHELL = os.environ.get('TEST_POWERSHELL') or shutil.which('powershell') or shutil.which('pwsh')


def run_script(path, *args):
    child_env = os.environ.copy()
    # PowerShell 7 module paths must not leak into a Windows PowerShell 5.1 child.
    for key in list(child_env):
        if key.upper() == 'PSMODULEPATH':
            del child_env[key]
    return subprocess.run(
        [SHELL, '-NoProfile', '-ExecutionPolicy', 'Bypass', '-File', str(path), *map(str, args)],
        capture_output=True, text=True, errors='replace', timeout=75, env=child_env,
    )


@unittest.skipUnless(SHELL, 'PowerShell required')
class Helpers(unittest.TestCase):
    def test_install_repeat_and_preserve_existing(self):
        with tempfile.TemporaryDirectory(prefix='fusion-starter-test-') as temp:
            script = ROOT / 'scripts/Install-Skill.ps1'
            first = run_script(script, '-SkillsRoot', temp)
            self.assertEqual(first.returncode, 0, first.stderr)
            second = run_script(script, '-SkillsRoot', temp)
            self.assertEqual(second.returncode, 0, second.stderr)
            installed = Path(temp) / 'fusion-360-printing/SKILL.md'
            installed.write_text('MY EXISTING CUSTOMIZATION', encoding='utf-8')
            third = run_script(script, '-SkillsRoot', temp)
            self.assertNotEqual(third.returncode, 0)
            self.assertEqual(installed.read_text(), 'MY EXISTING CUSTOMIZATION')

    def test_reject_remote_endpoint(self):
        result = run_script(ROOT / 'scripts/Test-FusionMcp.ps1', '-Endpoint', 'http://example.com/mcp')
        self.assertNotEqual(result.returncode, 0)
        self.assertIn('127.0.0.1', result.stderr)

    def check_mcp(self, mode, expect_success):
        requests = []

        class Handler(BaseHTTPRequestHandler):
            def log_message(self, *args):
                pass

            def do_POST(self):
                request = json.loads(self.rfile.read(int(self.headers['Content-Length'])))
                requests.append((request, dict(self.headers)))
                method = request['method']
                if method == 'notifications/initialized':
                    self.send_response(202)
                    self.end_headers()
                    return
                if method == 'initialize':
                    result = {'protocolVersion': '2025-03-26', 'capabilities': {'tools': {}},
                              'serverInfo': {'name': 'test-fusion', 'version': '1'}}
                elif method == 'tools/list':
                    result = {'tools': [{'name': 'fusion_mcp_execute', 'inputSchema': {
                        'type': 'object', 'properties': {'featureType': {'type': 'string'},
                                                      'object': {'type': 'object'}}}}]}
                else:
                    result = {'content': [{'type': 'text', 'text': json.dumps({
                        'success': mode != 'inner-error',
                        'output': 'FUSION_STARTER_VERSION=2706.1.17' if mode != 'no-output' else ''
                    })}], 'isError': mode == 'tool-error'}
                response = {'jsonrpc': '2.0', 'id': request['id'], 'result': result}
                if mode == 'rpc-error' and method == 'tools/call':
                    response = {'jsonrpc': '2.0', 'id': request['id'],
                                'error': {'code': -32603, 'message': 'deliberate failure'}}
                is_sse = mode == 'sse' and method == 'tools/call'
                body = (('data: ' if is_sse else '') + json.dumps(response)).encode()
                self.send_response(200)
                self.send_header('Content-Type', 'text/event-stream' if is_sse else 'application/json')
                self.send_header('MCP-Session-Id', 'test-session')
                self.send_header('Content-Length', str(len(body)))
                self.end_headers()
                self.wfile.write(body)

        server = ThreadingHTTPServer(('127.0.0.1', 0), Handler)
        thread = threading.Thread(target=server.serve_forever, daemon=True)
        thread.start()
        try:
            result = run_script(ROOT / 'scripts/Test-FusionMcp.ps1', '-Endpoint',
                                f'http://127.0.0.1:{server.server_port}/mcp')
        finally:
            server.shutdown()
            server.server_close()
            thread.join()
        self.assertEqual(result.returncode == 0, expect_success, result.stdout + result.stderr)
        calls = [r for r, _ in requests if r['method'] == 'tools/call']
        self.assertEqual(len(calls), 1, 'No repeated call after error')
        arguments = calls[0]['params']['arguments']
        self.assertTrue(arguments['object']['readOnly'])
        self.assertEqual(arguments['featureType'], 'script')
        self.assertIn('Application.get().version', arguments['object']['script'])
        for request, headers in requests:
            if request['method'] != 'initialize':
                self.assertEqual(headers.get('MCP-Session-Id'), 'test-session')
                self.assertEqual(headers.get('MCP-Protocol-Version'), '2025-03-26')

    def test_mcp_success(self):
        self.check_mcp('success', True)

    def test_mcp_failure_is_not_success(self):
        for mode in ('inner-error', 'tool-error', 'rpc-error', 'no-output', 'sse'):
            with self.subTest(mode=mode):
                self.check_mcp(mode, False)


if __name__ == '__main__':
    unittest.main(verbosity=2)
