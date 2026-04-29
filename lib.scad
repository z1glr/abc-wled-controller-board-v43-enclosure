include <BOSL2/std.scad>

$fs = 0.01;
$fa = 1;
// $fa = 12; // lower details for development

// pcb
pcb_length = 78.3;
pcb_width = 46.5;
pcb_height_bottom = 4;
pcb_height_top = 20;
pcb_thickness = 1.6;

pcb_hole_diameter = 3.6;
pcb_hole_screwhole_diameter = 2;
pcb_hole_inset_length = 1.9 + pcb_hole_diameter / 2;
pcb_hole_inset_width = 1.1 + pcb_hole_diameter / 2;

screw_diameter = 3;
screw_head_diameter = 5.5;

thickness = 1;
lip_height = 2 * thickness;

radius = 2;

box_length = pcb_length + 4 * thickness;
box_width = pcb_width + 4 * thickness;
box_height_bottom = pcb_height_bottom + pcb_thickness + thickness;
box_height_top = pcb_height_top + thickness;

hole_power_width = 10;
hole_power_middle = 8.4 + hole_power_width / 2;
hole_sec_width = 10;
hole_sec_middle = 7.5 + hole_sec_width / 2;
hole_pri_width = 20;
hole_pri_middle = 9.5 + hole_pri_width / 2;
hole_height = 7.5;

pcb_mount_corner_radius = min(pcb_hole_inset_length, pcb_hole_inset_width);
module abc_wled_controller_board_v43_enclosure_bottom(
  do_box_mounting_tabs = true,
  mounting_tab_hole_diameter = 3,
  mounting_tab_thickness = 2 * thickness,
  do_strain_relief = true,
  strain_relief_length = 25,
  strain_relief_width = 10,
  strain_relief_cable_tie_width = 3.5,
  strain_relief_cable_tie_height = 2
) {
  module pcb_mounting_pocket() {
    translate([pcb_length / 2, pcb_width / 2, thickness]) difference() {
        union() {
          cuboid(
            [pcb_hole_inset_length + pcb_mount_corner_radius, pcb_hole_inset_width + pcb_mount_corner_radius, pcb_height_bottom],
            anchor=BOTTOM + RIGHT + BACK,
            rounding=pcb_mount_corner_radius,
            edges=[FRONT + LEFT]
          );
          translate([-pcb_hole_inset_length, -pcb_hole_inset_width, 0]) cyl(h=pcb_thickness + pcb_height_bottom, d=pcb_hole_diameter, anchor=BOTTOM);
        }

        translate([-pcb_hole_inset_length, -pcb_hole_inset_width, 0]) cyl(l=pcb_height_bottom + pcb_thickness, d=pcb_hole_screwhole_diameter, anchor=BOTTOM);
      }
  }
  module corner_cut() {
    translate([pcb_length / 2 + thickness, pcb_width / 2 + thickness, box_height_bottom])
      cuboid(
        [pcb_hole_inset_length + screw_head_diameter / 2 + 2 * thickness, pcb_hole_inset_width + screw_head_diameter / 2 + 2 * thickness, lip_height],
        anchor=BOTTOM + RIGHT + BACK
      );
  }

  module box_mounting_tab() {
    back(box_width / 2 - radius) left(box_length / 2) difference() {
          cuboid(
            [mounting_tab_hole_diameter * 2, mounting_tab_hole_diameter * 2, mounting_tab_thickness],
            rounding=mounting_tab_hole_diameter,
            edges=[LEFT + FRONT, LEFT + BACK],
            anchor=BOTTOM + RIGHT + BACK
          );

          fwd(mounting_tab_hole_diameter) left(mounting_tab_hole_diameter) cyl(l=mounting_tab_hole_diameter, d=mounting_tab_thickness, anchor=BOTTOM);
        }
  }

  module strain_relief() {
    _length = strain_relief_length - radius;

    module _ellipse() {
      back(_length / 3 + strain_relief_width / 2) left(_length) yscale(1 / 3) rot(-90) difference() {
                cuboid([_length, _length, box_height_bottom], anchor=BOTTOM + LEFT + FRONT);
                pie_slice(ang=90, l=box_height_bottom, r=_length, anchor=BOTTOM);
              }
    }

    left(box_length / 2) difference() {
        union() {
          cuboid(
            [strain_relief_length, strain_relief_width, box_height_bottom],
            rounding=radius,
            edges=[LEFT + BACK, LEFT + FRONT],
            anchor=BOTTOM + RIGHT
          );

          _ellipse();
          yflip() _ellipse();
        }

        left(strain_relief_length - strain_relief_cable_tie_width) up(box_height_bottom / 2) cuboid([strain_relief_cable_tie_width, strain_relief_cable_tie_width + strain_relief_length * 2 / 3, strain_relief_cable_tie_height], anchor=LEFT);
      }
  }

  union() {
    // base-box
    difference() {
      union() {
        cuboid(
          [box_length, box_width, box_height_bottom], rounding=radius,
          edges=["Z"],
          anchor=BOTTOM
        );

        // add lip
        up(box_height_bottom) {
          cuboid([pcb_length + 2 * thickness, pcb_width + 2 * thickness, lip_height], anchor=BOTTOM);

          back(pcb_width / 2 - hole_power_middle) left(box_length / 2) cuboid([thickness, hole_power_width, lip_height], anchor=BOTTOM + LEFT);
          fwd(pcb_width / 2 - hole_sec_middle) left(box_length / 2) cuboid([thickness, hole_sec_width, lip_height], anchor=BOTTOM + LEFT);
          back(pcb_width / 2 - hole_pri_middle) right(box_length / 2) cuboid([thickness, hole_pri_width, lip_height], anchor=BOTTOM + RIGHT);
        }
      }

      up(thickness) cuboid([pcb_length, pcb_width, box_height_bottom - thickness + lip_height], anchor=BOTTOM);

      // remove corners from lip
      corner_cut();
      mirror([0, 1, 0]) corner_cut();
      mirror([1, 0, 0]) {
        corner_cut();
        mirror([0, 1, 0]) corner_cut();
      }
    }

    // pcb mounting pockets
    pcb_mounting_pocket();
    mirror([0, 1, 0]) pcb_mounting_pocket();
    mirror([1, 0, 0]) {
      pcb_mounting_pocket();
      mirror([0, 1, 0]) pcb_mounting_pocket();
    }
  }

  if (do_box_mounting_tabs) {
    box_mounting_tab();
    mirror([0, 1, 0]) box_mounting_tab();
    mirror([1, 0, 0]) {
      box_mounting_tab();
      mirror([0, 1, 0]) box_mounting_tab();
    }
  }

  if (do_strain_relief) {
    strain_relief();
    xflip() strain_relief();
  }
}

module abc_wled_controller_board_v43_enclosure_top() {
  corner_length = pcb_hole_inset_length + screw_head_diameter / 2 + 2 * thickness;
  corner_width = pcb_hole_inset_width + screw_head_diameter / 2 + 2 * thickness;

  module _hole() {
    translate([box_length / 2 - pcb_hole_inset_length - 2 * thickness, box_width / 2 - pcb_hole_inset_width - 2 * thickness]) zcyl(
        h=100,
        d=screw_diameter
      );
  }

  module _corner_fillet(_length, _width, _height) {
    translate([_length, _width, 0]) {
      fillet(l=_height - radius, r=radius, anchor=BOTTOM);
      fwd(radius) left(radius) fillet(l=_height, r=2 * radius, anchor=BOTTOM);

      translate([radius, radius, _height - radius])
        intersection() {
          torus(ir=radius, r_min=radius);
          zrot(180) pie_slice(h=radius, r=pcb_mount_corner_radius + radius, ang=90, anchor=BOTTOM);
        }
    }
  }

  difference() {
    union() {
      cuboid(
        [box_length - 2 * corner_length, box_width, box_height_top],
        rounding=radius,
        except=[BOTTOM],
        anchor=BOTTOM
      );
      cuboid(
        [box_length, box_width - 2 * corner_width, box_height_top],
        rounding=radius,
        except=[BOTTOM],
        anchor=BOTTOM
      );

      // corner-insides
      _length = box_length / 2 - corner_length;
      _width = box_width / 2 - corner_width;
      _corner_fillet(_length, _width, box_height_top);
      mirror([0, 1, 0]) _corner_fillet(_length, _width, box_height_top);
      mirror([1, 0, 0]) {
        _corner_fillet(_length, _width, box_height_top);
        mirror([0, 1, 0]) _corner_fillet(_length, _width, box_height_top);
      }

      // bottom
      cuboid(
        [box_length, box_width, thickness],
        rounding=radius,
        except=[BOTTOM, TOP],
        anchor=BOTTOM
      );
    }

    // hollow inside
    cuboid(
      [box_length - 2 * corner_length - 2 * thickness, box_width - 2 * thickness, box_height_top - thickness],
      rounding=radius,
      edges=[TOP],
      anchor=BOTTOM
    );
    cuboid(
      [box_length - 2 * thickness, box_width - 2 * corner_width - 2 * thickness, box_height_top - thickness],
      rounding=radius,
      edges=[TOP],
      anchor=BOTTOM
    );

    // corner-insides
    _length = box_length / 2 - corner_length - thickness;
    _width = box_width / 2 - corner_width - thickness;
    _height = box_height_top - thickness;
    _corner_fillet(_length, _width, _height);
    mirror([0, 1, 0]) _corner_fillet(_length, _width, _height);
    mirror([1, 0, 0]) {
      _corner_fillet(_length, _width, _height);
      mirror([0, 1, 0]) _corner_fillet(_length, _width, _height);
    }

    // mounting holes
    _hole();
    mirror([0, 1, 0]) _hole();
    mirror([1, 0, 0]) {
      _hole();
      mirror([0, 1, 0]) _hole();
    }

    // cables
    back(pcb_width / 2 - hole_power_middle) left(box_length / 2) cuboid([thickness, hole_power_width, hole_height], anchor=BOTTOM + LEFT);
    fwd(pcb_width / 2 - hole_sec_middle) left(box_length / 2) cuboid([thickness, hole_sec_width, hole_height], anchor=BOTTOM + LEFT);
    back(pcb_width / 2 - hole_pri_middle) right(box_length / 2) cuboid([thickness, hole_pri_width, hole_height], anchor=BOTTOM + RIGHT);
  }
}
