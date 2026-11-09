---
name: fusion-360-printing
description: Create, edit, or verify dimensionally specified Autodesk Fusion parts through native MCP. Use parameters, constrained sketches, measured geometry checks, technical drawings, and native exports for mechanical parts and 3D printing. Direct UI access is reserved for exceptional recovery or an explicit user request.
---

# Fusion 360 for 3D Printing

Build an editable design that the user can tune after the first print. This starter workflow uses Fusion through MCP, with direct UI access reserved for a proven essential exception or first-time MCP activation. A later explicit request to use Computer Use takes precedence. This skill supplies guidance, not a Fusion connection or permission to change unrelated projects.

## Native MCP and precision workflow

Use Fusion's installed native MCP for inspection, construction, parameters, document and cloud operations, drawings, exports, and verification. Read [native-mcp.md](references/native-mcp.md) for tool discovery, Python execution, units, saving, and bounded recovery. Python executed by `fusion_mcp_execute` is MCP access; it does not require opening Scripts and Add-ins. If normalized Fusion tools are absent, check the configured MCP endpoint and use the documented client for that same server before considering UI access. Do not install a second bridge when the native connection works.

### Direct UI access is an exception

First inspect the current tool schema, installed Fusion API documentation, and read-only state. An unknown capability, a single API error, or missing tool discovery is not evidence that UI is required. Use MCP screenshots and exported PDFs/images for routine visual checks.

Direct UI is justified only for a specific essential step that the available MCP/API demonstrably cannot perform, or to resolve an interactive blocker that prevents MCP access. Authentication remains a user handoff. State the evidence and the smallest required UI step before acting; existing authorization still applies, so do not introduce a separate approval ritual. Restrict the exception to that step, verify the result, and immediately return to MCP. Do not turn an exception into a full UI workflow. If the user forbids UI entirely, report the concrete limitation instead.

Before building, write a dimensional specification with units, reference origin/planes, hole centres, diameters, depths, and explicit fit allowances. Preserve ambiguities as assumptions, and resolve consequential missing dimensions. Derive nominal expected measurements from this specification, independently of the generated geometry.

Read [geometry-verification.md](references/geometry-verification.md) for actual BRep measurement, parameter regression and export verification. A passing parameter table or screenshot alone is insufficient for a claim of dimensional accuracy. CAD comparison tolerance is numerical, not a manufacturing tolerance.

This is a portable adaptation of [HazAT/codex-fusion-360](https://github.com/HazAT/codex-fusion-360), commit `9f7f54f4b63f28d29f4801c86fdabbcffc02a8bc`, retrieved 2026-11-08. Original MIT license is preserved in [LICENSE](LICENSE). Additions cover native MCP, measured geometry verification and automatic first drawings. No user-specific cloud files or credentials are included. During initial setup, discover or create a template in the new user's own account; do not assume a template from another account exists. Verify the installed version and license before promising drawing/export capabilities.

## Establish the design intent

- Inspect the open document, active component, units, timeline position, existing geometry, and saved state before editing. Preserve existing work.
- For measurements from videos, notes, or photos, record the final corrected values with their reference surfaces. Distinguish inside/outside diameter, radius, radial width, depth, and available height. Mark earlier values as superseded; keep assumptions separate. Speech and visible measurements must be reconciled before choosing geometry.
- Identify retained parts, mating surfaces, insertion/removal paths, and the intended print material. Ask only about missing information that changes the design; proceed with clearly labeled, reversible assumptions elsewhere.
- For more than one physical part, create and name a component for each part **before** its geometry, then activate it before sketching. Use an assembly-capable design type when required by the installed Fusion version. A single part may contain multiple construction bodies; do not automatically turn every body into a separate component.

## Parameterize before building

Make every dimension the user may tune a named parameter: measured envelope, fit clearance, wall/base thickness, feature size, spacing/count, and finishing radii. Use meaningful names, units, and comments describing the reference and purpose. Use expressions for dependent dimensions instead of repeating their evaluated numbers.

Keep measurements and manufacturing allowances independent. For a circular insert, for example:

```text
outer_d = housing_inside_d - 2 * radial_clearance
inner_d = outer_d - 2 * band_width
total_height = available_height - top_clearance
```

Define these parameters from the actual design; the example supplies relationships, not default dimensions. Use dimensionless integers for counts. Do not build circular dependencies or create a separate user parameter for an incidental origin coordinate already constrained geometrically. Ordinary user parameters are sufficient; a paid Configuration Table is not required just to make dimensions editable.

Read [modeling-and-printing.md](references/modeling-and-printing.md) for fits, patterns, fillet selection, or print preparation.

## Build an inspectable feature history

1. Save a named document early, once minimal useful geometry exists. Keep parametric history enabled for new editable designs; inspect the consequences before changing the modeling mode of an existing document.
2. Anchor sketches to the intended origin/reference geometry. Constrain position and shape, then dimension using parameter names. Prefer stable origin planes, axes, and deliberate construction geometry over faces likely to disappear after an edit.
3. Create the main solid, then functional cuts, holes, and joins. Check profile selection, operation type, direction, extent, and target body. A correct-looking preview can still create an unintended extra body.
4. For repeated details, create and verify one seed feature, then pattern the feature around a stable axis or direction. Drive count and spacing from design intent. Inspect the seed and the closure between the first and last instances.
5. Add small **finishing fillets near the end**, after the main geometry and patterns are stable. Use named radii such as `edge_radius`; keep a distinct `root_radius` or `base_edge_radius` when it serves a different purpose. A functional or structural fillet may belong earlier when later features depend on it.
6. Save after meaningful feature groups and before fragile edits. Prefer a saved, useful intermediate model to a long unsaved session.

Do not round every edge indiscriminately. Preserve mating faces, necessary sharp features, adequate wall thickness, and the intended bed-contact footprint. Inspect slot roots, tips, narrow gaps, and underside overhangs after rounding.

## Online models and automatic first drawings

Both the native part/assembly and its linked native drawing must be available online in the user's Fusion account, in the same suitable cloud project/folder. Local archives and PDFs alone do not complete the handoff. Verify the saved versions, target folder and completed cloud synchronization (`DataFile.isComplete`), and provide direct viewing links when available. Preserve existing access permissions; online availability does not require public sharing. If authentication or cloud access blocks either file, name the outstanding online deliverable explicitly.

Create the first drawing with Fusion's built-in drawing automation using the saved native F2T template through MCP. The user accepts that automatic result as the completed initial drawing. Do not expand this task into manual dimensioning, extra sections/details, layout polishing, new dimension-API qualification or a separate automation regression project.

- Read [drawing-mcp.md](references/drawing-mcp.md) for the native route. Use Auto-Select (`auto`), rather than only overall dimensions, when configuring automation. Respect the saved template's settings and inspect the resulting drawing rather than treating creation-input defaults as proof of persisted settings.
- Follow project conventions, otherwise use ISO, millimetres and a legible sheet size. Save the linked native drawing online beside the model and export the automatic dimensioned PDF into the local part folder.
- Perform a brief handoff check: intended source version, initialized sheets/views and automatic dimensions, successful nonempty PDF export, and every PDF page readable and unclipped. Check the displayed dimensions against verified geometry. Fix a concrete incorrect value or unreadable export, but do not demand complete functional dimension coverage for this first automatic drawing.
- Once these checks and cloud synchronization pass, hand over the first automatic drawing and stop. A separate failed experimental drawing/API test does not invalidate this verified deliverable.
- Add detailed functional dimensions, sections or other manual completion only on user request or when needed before a concrete print job. For such a detailed task, cover relevant overall dimensions, hole positions/diameters/depths, pockets, wall/base thicknesses, radii and functional clearances; qualify unfamiliar dimension APIs only then. Do not invent manufacturing tolerances.
- After initial creation, update drawings/PDFs only on request or at the latest before a concrete print job or print-job handoff. Routine model edits and intermediate CAD/mesh exports do not trigger automatic drawing updates. Before printing, confirm drawing/PDF source version and required functional coverage against the actual print model. Keep an older drawing's represented version explicit between updates.

## Verify before handing over

- Confirm the intended solid bodies/components exist, no unexpected bodies remain, and the timeline computes without unresolved errors. Inspect critical dimensions and clearances in the resulting geometry.
- Check the actual sketch/feature expressions, including pattern quantity and fillet radius. A parameter in the table is not proof that the feature uses it.
- When editability is central, save a baseline and test a modest change to a meaningful driving parameter. Check the affected features, restore the intended value, recompute, and verify the restored value before the final save/export. Test changed pattern topology when variable counts are part of the requirement.
- Check assembly/removal travel and cleaning access when relevant. Mark untested physical fit or print performance as provisional; CAD success does not establish either.
- Preserve a native editable archive, normally F3D for a self-contained design; use the appropriate native assembly export for linked designs. Supply a print mesh only when requested or useful for the agreed handoff. A mesh is not a substitute for parameter/history preservation.
- Verify export completion and file existence. File integrity, CAD geometry, slicer output, and physical fit are separate checks; report only those actually performed.

Finish with the saved design/version, the main tuning parameters, links to the model, technical drawing and dimensioned PDF, and any material unresolved fit issue or incomplete deliverable. Keep the model visible when practical.

## Exceptional Computer Use

Read [computer-use.md](references/computer-use.md) only when an explicit user request or the exception gate above justifies direct UI access. Follow the available Computer Use tool and skill instructions. Never reuse another session's coordinates, accessibility indices, or installation paths. Do not reopen a fragile dialog merely to reassure yourself after an adequate MCP verification.
