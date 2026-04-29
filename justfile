openscad := "openscad"
# openscad := "~/Downloads/OpenSCAD-2026.04.26-x86_64.AppImage"

export-stl:
	fd -d 1 -e .scad -E lib.scad -x {{openscad}} {} -o {.}.stl
