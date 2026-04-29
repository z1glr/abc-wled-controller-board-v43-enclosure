include <./lib.scad>

do_box_mounting_tabs = true;
mounting_tab_hole_diameter = 3;
mounting_tab_thickness = 2 * thickness;
do_strain_relief = true;
strain_relief_length = 25;
strain_relief_width = 10;
strain_relief_cable_tie_width = 3.5;
strain_relief_cable_tie_height = 2;

abc_wled_controller_board_v43_enclosure_bottom(
  do_box_mounting_tabs=do_box_mounting_tabs,
  mounting_tab_hole_diameter=mounting_tab_hole_diameter,
  mounting_tab_thickness=mounting_tab_thickness,
  do_strain_relief=do_strain_reliefrue,
  strain_relief_length=strain_relief_length5,
  strain_relief_width=strain_relief_width0,
  strain_relief_cable_tie_width=strain_relief_cable_tie_width,
  strain_relief_cable_tie_height=strain_relief_cable_tie_height
);
