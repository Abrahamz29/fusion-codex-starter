# Geometry verification

Define the expected values before construction. Retain a structured report with metric, actual, expected, comparison tolerance, units, and pass/fail. A model does not pass if any required check fails or was skipped.

Measure the resulting BRep, not only sketch or user parameters:

- Count physical components and solid bodies; check `isSolid` and timeline health after `computeAll()`.
- Use `preciseBoundingBox` for dimensions in its coordinate system. For rotated components transform measurement points into the specified part/reference frame; a global axis-aligned box is not the rotated part's width.
- For cylindrical bores inspect `Cylinder.cast(face.geometry)`, radius, axis, centres and face extents. Compare the complete expected set, not merely each face that happened to be found. Distinguish holes from external cylinders and counterbores using topology, location and surrounding solid. Arbitrary axis origin Z is not hole depth.
- Verify through openings with topology/extents and, where useful, volume or cross-sections. A radius alone does not establish a through-hole. Check minimum wall thickness and clearances for the actual feature shapes when relevant.
- Inspect feature/dimension expressions and sketch constraint state. Do not fix all geometry merely to hide missing dimensions.

For the simple axis-aligned four-hole test plate, compare min corner `(0,0,0)` mm, max corner `(80,50,6)` mm, exactly one solid, four cylindrical bore faces of diameter `5.5` mm at `(10,10),(70,10),(10,40),(70,40)`, and each bore's Z bounds `0..6` mm. Independently compare volume with `80*50*6 - 4*pi*(5.5/2)^2*6`. This special-case volume check is not a general proof for arbitrary topology.

The tested numerical tolerances were `0.00001 mm` for nominal linear CAD comparisons and `0.001 mm³` for volume. They are chosen for analytic geometry verification and say nothing about machining or printing accuracy. Manufacturing tolerances require separate specification and process validation.

## Editability regression

Save a native baseline. Change a meaningful driving parameter within its valid range, recompute, and compare affected geometry against new expectations. Restore the original expression in a `finally` block, recompute and remeasure before final export. Do not suppress exceptions; restoration is cleanup, not a claim of success.

Test plate example: width `80 -> 90 -> 80 mm`; right hole centres must move `70 -> 80 -> 70 mm`, while their adjacent edge offsets remain `10 mm`. Both sketches and solids must remain healthy. Test additional parameter families only when their effects matter to the deliverable.

## Export evidence

Export F3D for the editable self-contained design and STEP when requested. Check the export API result and actual nonempty files. Reimport into separate temporary documents when file validity/geometry is a required claim; remeasure imported STEP geometry and verify native parameters/history after F3D import. Preserve the final working model and close only disposable documents created by this test. Report separately: CAD geometry, editability, exported-file reopening, slicer checks, and physical fit. Do not claim tests that were not run.
