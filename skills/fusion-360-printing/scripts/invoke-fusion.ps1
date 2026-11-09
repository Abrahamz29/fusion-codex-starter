[CmdletBinding(DefaultParameterSetName='List')]
param(
    [Parameter(Mandatory=$true)][uri]$Endpoint,
    [Parameter(ParameterSetName='List')][switch]$ListTools,
    [Parameter(Mandatory=$true, ParameterSetName='Script')][string]$ScriptPath,
    [Parameter(ParameterSetName='Script')][switch]$ReadOnly,
    [Parameter(Mandatory=$true, ParameterSetName='Request')][string]$RequestPath,
    [string]$OutputPath,
    [ValidateRange(1, 300)][int]$TimeoutSec = 30
)
$ErrorActionPreference = 'Stop'
if ($Endpoint.Scheme -ne 'http' -or $Endpoint.Host -ne '127.0.0.1' -or
    $Endpoint.AbsolutePath -ne '/mcp' -or $Endpoint.Query -or $Endpoint.Fragment -or $Endpoint.UserInfo) {
    throw 'Erwartet wird der lokale Fusion-Endpunkt http://127.0.0.1:<PORT>/mcp.'
}
$headers = @{Accept='application/json, text/event-stream'}
Add-Type -AssemblyName System.Net.Http
function Send-Rpc($Payload) {
    $body = $Payload | ConvertTo-Json -Depth 50 -Compress
    $handler = [System.Net.Http.HttpClientHandler]::new()
    # This endpoint is always loopback; Windows proxy discovery is unnecessary.
    $handler.UseProxy = $false
    $handler.AllowAutoRedirect = $false
    $http = [System.Net.Http.HttpClient]::new($handler)
    $http.Timeout = [TimeSpan]::FromSeconds($TimeoutSec)
    $request = [System.Net.Http.HttpRequestMessage]::new([System.Net.Http.HttpMethod]::Post, $Endpoint)
    $response = $null
    try {
        foreach ($key in $headers.Keys) {
            [void]$request.Headers.TryAddWithoutValidation($key, [string]$headers[$key])
        }
        $request.Content = [System.Net.Http.StringContent]::new($body, [Text.Encoding]::UTF8, 'application/json')
        $response = $http.SendAsync($request).GetAwaiter().GetResult()
        [void]$response.EnsureSuccessStatusCode()
        $responseHeaders = @{}
        foreach ($entry in $response.Headers) { $responseHeaders[$entry.Key] = $entry.Value -join ',' }
        foreach ($entry in $response.Content.Headers) { $responseHeaders[$entry.Key] = $entry.Value -join ',' }
        [pscustomobject]@{
            Content=$response.Content.ReadAsStringAsync().GetAwaiter().GetResult()
            Headers=$responseHeaders
        }
    } finally {
        if ($response) { $response.Dispose() }
        $request.Dispose()
        $http.Dispose()
    }
}
function Read-Rpc($Response) {
    $raw = [string]$Response.Content
    if ($raw.TrimStart().StartsWith('event:') -or $raw.TrimStart().StartsWith('data:') -or
        ([string]$Response.Headers['Content-Type']) -match 'text/event-stream') {
        throw 'SSE-Antwort: Dieser JSON-Helfer braucht einen vollwertigen MCP-Client fuer Event-Streams.'
    }
    $parsed = $raw | ConvertFrom-Json
    if ($parsed.error) { throw ('MCP JSON-RPC-Fehler: ' + ($parsed.error | ConvertTo-Json -Compress -Depth 10)) }
    if ($null -eq $parsed.result) { throw 'MCP-Antwort enthaelt kein result.' }
    if ($parsed.result.isError) { throw ('MCP-Toolfehler: ' + ($parsed.result | ConvertTo-Json -Compress -Depth 20)) }
    foreach ($item in $parsed.result.content) {
        if ($item.type -eq 'text' -and $item.text.TrimStart().StartsWith('{')) {
            $inner = $item.text | ConvertFrom-Json
            if (($inner.PSObject.Properties.Name -contains 'success' -and $inner.success -eq $false) -or $inner.error) {
                throw ('Fusion-Ausfuehrung fehlgeschlagen: ' + $item.text)
            }
        }
    }
    $parsed.result
}
$initResponse = Send-Rpc @{
    jsonrpc='2.0'; id=1; method='initialize'; params=@{
        protocolVersion='2025-03-26'; capabilities=@{};
        clientInfo=@{name='fusion-codex-starter';version='1.0.0'}
    }
}
$init = Read-Rpc $initResponse
if (-not $init.protocolVersion) { throw 'MCP initialize lieferte keine Protokollversion.' }
$session = $initResponse.Headers['MCP-Session-Id'] -join ''
if ($session) { $headers['MCP-Session-Id'] = $session }
$headers['MCP-Protocol-Version'] = $init.protocolVersion
Send-Rpc @{jsonrpc='2.0';method='notifications/initialized'} | Out-Null
if ($PSCmdlet.ParameterSetName -eq 'List') {
    $message = @{jsonrpc='2.0';id=2;method='tools/list';params=@{}}
} elseif ($PSCmdlet.ParameterSetName -eq 'Script') {
    $message = @{jsonrpc='2.0';id=2;method='tools/call';params=@{
        name='fusion_mcp_execute';arguments=@{featureType='script';object=@{
            script=[IO.File]::ReadAllText((Resolve-Path -LiteralPath $ScriptPath).ProviderPath, [Text.Encoding]::UTF8)
            readOnly=[bool]$ReadOnly
        }}
    }}
} else {
    $request = Get-Content -LiteralPath $RequestPath -Raw -Encoding UTF8 | ConvertFrom-Json
    if (-not $request.name -or $null -eq $request.arguments) {
        throw 'RequestPath muss ein JSON-Objekt mit name und arguments enthalten.'
    }
    $message = @{jsonrpc='2.0';id=2;method='tools/call';params=$request}
}
$response = Send-Rpc $message
if ($OutputPath) { $response.Content | Set-Content -LiteralPath $OutputPath -Encoding UTF8 }
Read-Rpc $response
