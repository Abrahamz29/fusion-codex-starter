# Modeling and printing decisions

Read the sections needed for the current part. These are design heuristics, not universal manufacturing limits.

## Components and constraints

Create, name, and activate the component before making its sketches and bodies. Confirm ownership in the browser after the first feature. Creating components from finished bodies can organize them, but does not necessarily move all original sketch/history dependencies into each new component. Use intentional joints or references for relationships between separate parts; check that local edits do not unintentionally move the assembly. [Autodesk: create components](https://help.autodesk.com/view/fusion360/ENU/?contextId=ASM-NEW-COMPONENT)

Prefer geometric constraints for coincidence, symmetry, concentricity, and orientation; use parameters for sizes and offsets that express design intent. Do not hide underconstrained geometry by fixing everything in place.

## Parameters and fit

Keep three categories distinguishable in names/comments:

| Category | Examples | Reason |
| --- | --- | --- |
| Measured inputs | `housing_inside_d`, `available_height` | Record the object being fitted |
| Design choices and allowances | `radial_clearance`, `wall_thickness`, `slot_width` | Tune without rewriting the measurements |
| Derived geometry | `outer_d`, `inner_d`, `cut_depth` | Keep dependencies consistent |

Document whether clearance is **per side** or **total**. A radial allowance changes a diameter twice; an axial allowance usually changes height once. Keep fit allowances distinct from any calibrated material compensation.

Fusion accepts expressions and comments in the parameter table. Inspect the expression as well as the evaluated value. If batching edits with Automatic Compute paused, restore computation and recompute before calling the result complete. [Autodesk: parameters](https://help.autodesk.com/cloudhelp/ENU/Fusion-Model/files/SLD-MODIFY-CHANGE-PARAMETERS.htm)

Use a fit coupon or small representative section when a full print would be costly and tolerances are unknown. Check the actual printer, material, orientation, and mating part; do not impose one clearance or global shrinkage percentage on every design.

## Patterns and narrow features

Inspect the seed before patterning: slot width, remaining base, cut depth, and whether the result is a join/cut/new body. Patterning a defective seed only multiplies the defect.

A circumference-based count can be an estimate, but arc length, chord distance, and straight-slot width are different measurements. If minimum tooth/web thickness matters, measure the narrowest remaining section of the actual patterned geometry. Check the final wraparound gap as well as interior instances.

Choose pattern computation appropriate to the geometry. Identical instances may work for repeated copies; features whose extents depend on local surrounding faces can require a different computation mode. Verify the result rather than assuming the default is correct.

## Fillets and chamfers

Use small, separately tunable finishing radii after the main functional features. Choose their values from the local thickness, neighboring gaps, intended feel, and printer resolution. A tiny radius that exists in CAD may be barely represented by the sliced layers. Avoid claiming a small cosmetic radius provides proven structural strength.

Standard Fillet accepts edges, faces, or features. Rule Fillet's **All Edges** applies to the selected faces/features; it does not prove the entire model was selected. Tangent Chain follows tangent geometry, not every nearby edge. Select the intended coverage and inspect it. Autodesk also documents Ctrl (Windows) or Command (macOS) to modify selections after the preview appears; use this only if the current Computer Use API supports the necessary interaction. [Autodesk: fillet selection and rules](https://help.autodesk.com/cloudhelp/ENU/Fusion-Model/files/SLD-REF-FILLET.htm)

For a patterned cut, compare the original seed's floor/side junction with a neighboring instance. Later feature selections may cover some surviving edges but miss other cut-generated edges. An enabled OK confirms the operation can commit; a disabled OK is not proof that no sharp edges remain.

If a fillet fails, inspect the selection and radius relative to local geometry. Reduce the radius or separate conflicting edge groups when justified. Avoid accumulating repeated speculative fillets. Keep a clear role for every finishing feature.

For a part printed flat, a bottom fillet can introduce steep early overhangs and reduce bed contact. Consider a small chamfer or a preserved flat footprint where appropriate. A lead-in chamfer can also help mating parts assemble. Do not replace a user's existing bottom fillet without considering its purpose and the requested scope. [Prusa: fillets and chamfers](https://help.prusa3d.com/article/modeling-with-3d-printing-in-mind_164135#fillet-vs-chamfer)

## ABS/ASA and print handoff

- Choose orientation with layer adhesion, overhangs, mating faces, and the most vulnerable thin features in mind. Consider splitting parts only when the assembly and printing tradeoff justifies it.
- Check thin walls and details against the selected extrusion width and sliced toolpaths. Rely on the slicer preview to establish whether they will actually print.
- ABS/ASA dimensions and warping depend on the filament, machine, geometry, and process. Use the filament/printer maker's current profile guidance and a representative test; keep temperature settings and compensation out of reusable CAD defaults.
- For cleaning parts, inspect snag points, blind recesses, drainage, grip access, and the path needed to lift the part past retained hardware. Smooth-looking CAD surfaces alone do not establish easy cleaning.
- Export a mesh with sufficient tessellation for curved surfaces, verify units/scale, and inspect the sliced result when print preparation is in scope. Preserve the native file independently. [Prusa: design for printing](https://help.prusa3d.com/article/modeling-with-3d-printing-in-mind_164135)
