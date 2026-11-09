# Native Fusion MCP

## Discovery and routing

Discover the currently connected Fusion tools. The tested Fusion 2706.1.17 exposes `fusion_mcp_read`, `fusion_mcp_execute`, `fusion_mcp_update`, and an electronics reader. Tool schemas can change; inspect them rather than assuming generic create/extrude tools exist. Keep routine work on MCP, including document selection, cloud naming/folders, saving, drawing automation, export, and verification.

Missing normalized tools do not mean the MCP server is unavailable. Inspect `codex mcp get fusion`, then use the same configured endpoint through the client below. Distinguish transport failure, an interactive-command guard, an unavailable API operation, and an application/API runtime error. They require different remedies; none is an automatic reason to start clicking through Fusion.

Use `fusion_mcp_read` with `queryType: apiDocumentation`, `searchPattern`, and `apiCategory` to inspect installed API documentation. Use Python for geometry creation and measurement:

```json
{"featureType":"script","object":{"script":"import adsk.core\ndef run(context):\n    print(adsk.core.Application.get().version)\n","readOnly":true}}
```

Send that argument to `fusion_mcp_execute`. Define `run` with exactly one argument. Python running through this tool is the native MCP workflow, not a reason to launch Scripts and Add-ins. Prefer supported data APIs over commands that open interactive dialogs. Do not guess internal text commands or use undocumented test hooks to bypass a blocker.

Only claim `readOnly` for scripts that actually make no changes. Let exceptions propagate. A transport HTTP 200 is not proof of success: inspect MCP `isError` and the inner JSON `success`/error/traceback, then independently inspect the result. A script can fail after a successful mutation; record created IDs and checkpoints before optional metadata or exports. Inspect the partial result before resuming, rather than repeating creation or Save As.

Read the current documents before editing. Create a separate document for an example or regression test. Track documents created during failed attempts so that cleanup never closes unrelated work. Never rerun a partially completed mutation blindly against the user's current model.

## Documents, cloud and visual evidence

Both native model and linked native drawing must be online in the intended Fusion cloud project/folder before the handoff is complete. Confirm synchronization for each and provide viewing links. Local CAD/PDF exports do not replace either online file; preserve existing access permissions.

- Resolve document and folder IDs through MCP before asking the user to select files. Search project-root files as well as nested folders; a template can be saved in the project root.
- Use supported document operations or `Document.saveAs`, `DataFile.name`, `DataFile.move`, and native exports as applicable. Preserve existing files and use the intended cloud folder. After Save As or a move, metadata can be temporarily incomplete or stale; read the same file ID again after a bounded wait instead of creating another copy.
- Verify the saved version, `DataFile.isComplete`, folder, model references, and exported files. Do not confuse a transport-level open success with an initialized drawing document.
- Use MCP screenshots for routine model views. For drawings, export a native PDF and inspect every page locally. Viewing an exported image/PDF does not require direct Fusion UI access. Capture the application UI only when diagnosing a specific exception.

API lengths in numeric geometry and `createByReal` use centimetres, areas cm², volumes cm³, angles radians. Convert explicitly to requested units. Use `ValueInput.createByString('6 mm')` and parameter expressions for dimensions. `FusionUnitsManager.defaultLengthUnits` was read-only in the tested version; display units do not change the API unit convention.

Drawing paper-space APIs require separate verification: read their installed documentation and check a small rendered example before batching changes. A plausible `DrawingPoint.coordinate` difference alone does not prove the displayed dimension value or association. See [drawing-mcp.md](drawing-mcp.md).

For sketches, verify constraints rather than assuming a rectangle helper creates horizontal/vertical constraints. The tested rectangle required those constraints explicitly. Use `setOneSideExtent` with `DistanceExtentDefinition` or `ThroughAllExtentDefinition`, avoiding retired extent methods.

## Open commands and exceptional UI steps

Read `queryType: activeCommand` and, if needed, a genuinely read-only script before planning a mutation. Avoid opening native editors merely to inspect settings when a data API provides adequate evidence.

The tested MCP rejects normal `script` and `document` operations while an interactive command is active. If it rejects a call before executing the script, a second normal script calling `terminateActiveCommand` cannot solve that guard. Do not disguise `terminateActiveCommand`, changes, or `executeTextCommand` as read-only.

If a supported MCP route cannot finish or cancel the command, apply the SKILL.md emergency gate. A narrowly scoped UI action to finish the agent's own dialog may be justified; leave unrelated edits alone. State the exact MCP rejection and the minimum step. Use existing authorization rather than repeatedly asking for permission. If the user must perform the step, request it once with the precise dialog/button and resume independent work. Afterward verify the active command through MCP and return to normal MCP operations.

## Bounded recovery and pending calls

- A timed-out HTTP client does not establish that Fusion stopped executing. Do not queue additional CAD mutations, exports or opens while execution is unresolved. Keep one operation in flight; retain its response path and created IDs. Before a restart, distinguish a still-progressing call from an actual application blockage and account for partial work; a timeout alone is insufficient.
- After a call has completed, inspect partial state with one bounded read-only probe. For an unresponsive connection, a protocol/transport health check can distinguish an absent server from a queued application operation; do not create a growing queue of state scripts.
- Retry a failed mutation only after identifying what changed and what the retry will do differently. Do not reopen the same known-fragile drawing/editor to obtain redundant confirmation. Mark a reproducibly failing path unvalidated until new evidence or a fix justifies another test.
- Restart Fusion only as recovery of an actual application blockage, under the user's authorization and after accounting for unsaved work. Preserve verified cloud/local checkpoints and recovery files. Do not require renewed permission for an already authorized restart, but do not infer that permission for unrelated work.
- Allow at most one controlled restart for the same failing path. After restart, restore a known-good model and connection; do not immediately replay the failing drawing/editor sequence. If the blocker persists, preserve completed work and state the exact missing deliverable instead of alternating UI retries and restarts.

## Windows fallback when tools are not yet loaded

Use the endpoint actually shown in Fusion Preferences > General > API and configured in the client. Autodesk currently documents port 27182 as its default; never replace a working custom port with that default. Fusion must be running with MCP enabled.

`scripts/invoke-fusion.ps1` is a bounded Streamable HTTP JSON-response fallback. Always pass `-Endpoint`. Use `-ListTools` for discovery, `-ScriptPath` with `-ReadOnly` only for genuinely read-only code, or `-RequestPath` containing `{ "name": "tool_name", "arguments": {...} }`. `-OutputPath` optionally preserves the raw response. Initialization and initialized notification are included. The helper rejects SSE responses rather than pretending to parse them; use a full MCP client for SSE. It does not retry timeouts and is not a general-purpose streaming transport.

For normal use prefer connected tools. No separate Python server, API key or third-party add-in is needed for Fusion's native local server. The server is not the separate Autodesk Fusion Data MCP cloud service.
