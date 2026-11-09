# Drawings and templates through MCP

Use the installed native drawing API and an existing F2T template through MCP. This reference follows the initial automatic drawing scope in SKILL.md. Both model and linked drawing must be saved online and fully synchronized; local files alone are insufficient. Direct application UI remains an exceptional, narrowly scoped recovery step.

## Native route

1. Inspect the saved source model, version, folder and active command through MCP. Discover the installed `adsk.drawing` API before using it. Preserve the original drawing when testing a new API path.
2. Find an existing native template by cloud ID or name, including project-root files. Inspect its extension (`f2t`), saved layout and synchronization. Use native document/data APIs for opening, naming, moving and saving; a file dialog is not the default selection or save route.
3. Where available, use `DrawingManager.createDrawingInput` with the saved model DataFile, automatic creation, `FromTemplateBaseDocumentType` and `templateFile`. Invoke Fusion's built-in automation, rather than building a second drawing engine or installing another add-in. Short Python calls executed by MCP are compatible with this route; a separate script launched through Fusion's UI is not required.
4. For construction assessment, explicitly use `AutomaticDimensionStrategyType` (`auto`) for applicable component and assembly settings when configuring creation inputs. `OverallDimensionStrategyType` only supplies overall dimensions. Choose orthogonal and isometric views, appropriate hole/thread information, center marks/lines, and intentional component exclusions. Do not add unagreed manufacturing tolerances.
5. Record the created drawing ID immediately. Verify cloud completion, linked source version, sheet initialization and generated automatic dimensions before exporting. Creating a cloud file is not proof that opening, PDF export or evaluation succeeded.
6. Export with the native drawing export manager. Verify a nonempty file, render all PDF pages locally, and compare the displayed values and layout with measured geometry. Keep CAD validity, drawing correctness, automation completion and physical fit as separate statuses. For the first drawing, accept the checked automatic result and hand it over without unsolicited manual additions or full functional-coverage work.

## First drawing stopping point

Use the existing saved F2T, generate once, save the native drawing online, export the PDF and perform the brief source/value/readability check. Completion does not require a separate test plate, a new dimension API or manual additions. Template development/regression and detailed functional drawings are separate tasks, undertaken when requested or required for a concrete print job.

## Persisted template settings

Native automation preferences for one creation input are not automatically a saved reusable template. Reuse and verify an existing native F2T first. When persistence needs an operation not exposed by the installed API, record that exact gap before considering the limited UI exception; do not open configuration dialogs speculatively.

If the native template editor is the proven necessary exception, use its explicit Save as New Drawing Template or Update Selected Template action. OK alone may affect only the current creation. Return to MCP for cloud saving/naming, folder checks and subsequent use wherever the installed API supports it.

Verify a saved template by reopening it and generating an isolated test drawing. Confirm actual layout, saved automation behavior, functional dimensions and the PDF. Merely assigning `CreateDrawingInput.templateFile` and inspecting input defaults does not establish the template's persisted strategy; such defaults were observed after choosing a saved template. A created test drawing without successful inspection is still unvalidated.

## Qualifying a new dimension API path

This section applies only when a detailed manual dimensioning task is in scope; it is not part of producing the first automatic drawing. Before a large batch, add a representative dimension to a disposable or separately saved drawing, export it and inspect the displayed number, scale, placement and association. Include the curve/view type actually needed. Expand only after that rendered example passes. Do not treat correct paper-space coordinate subtraction as proof of the generated dimension.

If rendered values are wrong, stop the batch. Retain the original and last good version, label failed exports as invalid, and resume from a verified checkpoint. Do not invent a scale correction or replace a geometric dimension with arbitrary displayed text. A failure in one installed version does not prove that the API is universally unsupported.

Avoid calling convenience functions that may open interactive editors during an unattended sequence. Discover actual behavior in an isolated test before including them in production. A nominal API return type does not guarantee that the operation is noninteractive.

## New account and version boundaries

A downloaded skill does not carry another user's native F2T or cloud entitlement. Find an existing template in the current user's account or create and persist one using supported installed capabilities. During initial setup, reuse the small setup model for the required saved-template/reopen/drawing/PDF check. Do not add a second regression project.

API availability can vary. Inspect the installed drawing documentation. If a method is missing or opens an interactive editor, record that specific behavior and preserve the verified model. Do not call `Sheet.tidyUp` as an assumed headless cleanup; it has opened an interactive editor in a prior installation. Report missing drawing capability separately from a working model/MCP connection.
