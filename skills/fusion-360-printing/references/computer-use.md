# Fusion Computer Use: reliable operation and recovery

This is an emergency reference, not the normal Fusion workflow. Use it only after the direct-UI exception gate in SKILL.md is satisfied, or when the user explicitly requests Computer Use. State the specific blocker and limit UI interaction to the smallest necessary step; then return to MCP. Inspect documents, geometry, saving and cloud state through MCP whenever that remains available.

These observations came from a real macOS Fusion modeling session. They describe things to inspect, not fixed coordinates, guaranteed shortcuts, or a script to replay. Read the current Computer Use API and Fusion UI before acting.

## Start with a checkpoint

Inspect the document title/version, saved indicator, active component, units, model, timeline endpoint, and open modal dialogs. If the user resumed after a crash, look for recovery/open recent options before rebuilding. Do not assume a disconnected tool means the CAD application crashed.

Save a named, minimally useful model early. Confirm the save completed. Save again after base geometry, functional patterns, and finishing edits. Export a native checkpoint before a long or fragile continuation when that would materially reduce recovery cost.

When an editable-document limit blocks saving, first inspect the current entitlement and document state through MCP. Use UI only if an essential remaining operation meets the exception gate. The modeling task does not authorize changing an unrelated design's status. Follow existing authorization, preserve originals, and verify required backups. Do not assume exporting frees an editable slot or hard-code a license limit.

## Use the current window, not yesterday's coordinates

- Accessibility-backed fields/buttons are usually preferable to coordinates. Canvas geometry, the browser tree, and timeline icons may need fresh screenshots.
- A HUD value editor, a command palette, the Parameters window, and the main canvas can each be the active window. Coordinates from one are not valid in another.
- After input, refresh UI state before deciding the next action. A screenshot may be cropped to the active popup. Reacquire the main window or the actual dialog instead of applying remembered pixel offsets.
- Prefer command search or labeled menus when reliable. Confirm that search found the intended command before pressing Return; text entered into a search field is not evidence of a matching result.
- Build selections before entering a value when preview mode makes further selection awkward. If extending a preview selection requires a modifier that the tool cannot hold, use an available native UI alternative; do not invent unsupported tool methods.

## Expression entry

1. Explicitly focus the field and select its current contents before entering a parameter name or expression.
2. Inspect whether autocomplete is still active. Accepting a suggestion and committing the CAD command can be separate actions.
3. Use the visible confirmation controls or documented keyboard behavior, then verify the resulting expression and value. In the observed session, Tab sometimes validated a field and Return sometimes only accepted autocomplete. Neither is a universal two-key recipe.
4. Read the new feature or Parameters table to confirm linkage. Seeing `edge_radius` typed into a HUD is insufficient if the command never committed.

Filter the Parameters table to the relevant name when it is large. Locate current fields from fresh accessibility state rather than retaining stale row indices. Avoid deleting unused parameters during unrelated work merely to tidy the table.

## Timeline and fillet traps

An apparently disabled gray feature may be **after the timeline marker**. Inspect the marker before repeatedly double-clicking or trying to recreate the feature. Move to the end of history when the task requires the final model; preserve deliberate rollback when editing an earlier design stage.

Inspect existing fillets before adding new ones. Distinguish bottom edges, tooth/slot edges, and functional root radii. Preserve useful existing features and connect their radii to named parameters where requested.

Check that a successful fillet covers the intended edges. Inspect the original seed, repeated instances, and closure. Never treat a later disabled OK button as an all-edges inspection.

## Bounded recovery

If an action leaves the UI unchanged, refresh once and inspect focus, modal state, selection state, and the timeline. Try a materially different supported route. After two unsuccessful routes to the same control, stop blind retries and diagnose the actual blocker.

If an error follows an input action, re-inspect before repeating it: the action may already have succeeded. Reset/reconnect the automation session before considering restarting Fusion. A forced restart can discard unsaved work; it is not a routine tool-recovery step.

Do not alternate between failing UI actions and Fusion restarts to pursue the same operation. Follow the recovery limits in native-mcp.md. Once the exceptional step succeeds, use MCP for the remaining work. If capture or activation still fails after the documented recovery attempt, stop UI input and report the actual failure; do not keep clicking the same control.

Do not assign a cause to a crash or timeout without evidence. Preserve the last verified save/export, explain what is known, and report a concrete blocker if control cannot be recovered. Never silently rebuild over existing work.

## Completion evidence

Confirm the intended feature committed, the timeline computes, the approved parameter values were restored, and the final save/export succeeded. Filesystem checks can establish that an archive exists and is intact; they do not establish correct geometry or physical fit.

Once the requested result is verified, stop. Reopening a fragile dialog for redundant reassurance can waste time or jeopardize a stable handoff. Leave no unnecessary command active. Report UI-access failures separately from the status of already verified deliverables.
