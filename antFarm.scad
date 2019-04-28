
wall = 4;
x = 50;
y = 50;
z = 20;
innerX = x - 2*wall;
innerY = y - 2*wall;
innerZ = z - 2*wall;
coverWall = 1.5;
coverZ = 1.5;
tol = 0.5;
openingSide = 12;
openingWidth = sqrt(2*openingSide*openingSide);


shutter();

/*
all();
*/
module all() {

simpleModule();
translate([0, -y-2*tol, 0])
  wetModule();

translate([x/2, 0, 0])
    join(1);

translate([0, +y/2- wall/2, 0])
    rotate([0, 0, -90])
        shutter();

}

module simpleModule() {
    antModule(0);
}

module wetModule() {
    antModule(1);
}

module antModule(type) {
    difference() {
        union() {
            difference() {
                cube([x, y, z]);
                translate([wall, wall, wall])
                cube([innerX, innerY, z]);
                // south opening
                if (type == 0) {
                    translate([x / 2, 0, 0])
                    opening();
                }
                // north opening
                translate([x / 2, innerY + wall, 0])
                opening();
                // west opening
                translate([wall, innerY / 2 + wall / 2, 0])
                rotate([0, 0, 90])
                opening();
                // east opening
                translate([x, innerY / 2 + wall / 2, 0])
                rotate([0, 0, 90])
                opening();
            }
            translate([x / 2, y / 2, wall / 2 - tol])
                scale([0.7, 0.7, z])
                    import("innerShape.stl");

            // cover screw pod
            if(type == 0) {
                translate([wall/2, wall/2, 0])
                    corner(6, z, 5, 2);
            } else {
                translate([wall/2 + 1, wall/2 + 7.9, 0])
                corner(4, z, 5, 2);
            }
            // cover screw pod
            translate([x - wall/2, y - wall/2, 0])
                rotate([0, 0, 180])
                corner(6, z, 5, 2);
        }
        // Window recess
        translate([coverWall, coverWall, z - coverZ])
            cube([x - 2 * coverWall, y - 2 * coverWall, z]);
    }

    // wet module: pierced wall
    if(type == 1) {
        rowCount = 7;
        translate([wall, 8.8, 0]) {
            difference() {
                cube([innerX, 2, z - coverZ]);
                for (row = [1 : rowCount])
                    translate([0, 0, 2*wall - 1 + (innerZ / rowCount) * row])
                        holeRow();
            }
        }
    }

}

module holeRow() {
    count = 25;
    holeDiam = 0.7;
    translate([]) {
        for (hole = [1 : count]) {
            translate([hole*(innerX / count), 3, 0]) {
                rotate([90, 0, 0])
                    cylinder(d=holeDiam, h = 6);
            }
        }
    }
}
module opening() {
    difference() {

        translate([-openingWidth/2, wall/2, 0])
            rotate([0, 0, -45])
                cube([openingSide, openingSide, z]);
        translate([-20, wall + 0.2, 0])
            cube([40, 20, 40]);
        translate([-20, -20 - 0.2, 0])
            cube([40, 20, 40]);
    }

}

shutterSide = openingSide - tol;
shutterWidth = sqrt(2*shutterSide*shutterSide);

module shutter() {
    difference() {
        translate([-shutterWidth/2, wall/2, 0])
            rotate([0, 0, -45])
                cube([shutterSide, shutterSide, z]);

        translate([-20, wall, 0])
            cube([40, 20, 40]);
        translate([-20, -20, 0])
            cube([40, 20, 40]);
        translate([-20, 0, z])
            cube([40, 20, 40]);
        translate([-shutterWidth, coverWall, z - coverZ])
            cube([x - 2*coverWall, y - 2*coverWall, z]);
    }
    /*
    translate([4, wall, wall + 0.3])
        sphere(d=1, $fn=50);
    translate([-4, wall, wall + 0.3])
        sphere(d=1, $fn=50);
    */
}

module join(distance) {
    doorDiam = 7;
    difference() {
        union() {
            shutter();
            translate([- shutterSide/2, -distance-0.1, 0])
                cube([shutterSide, distance + 0.2, z]);
            translate([0, -distance, 0])
                mirror([0, 1, 0])
                    shutter();
        }
        #translate([0, -wall - distance - 1, doorDiam + 1])
            rotate([-90, 0, 0])
                cylinder(d=doorDiam, h = 2 + distance + 2*wall, $fn=100);
    }
}

module corner(side, height, zOffset, holeDiam = 3) {
    difference() {
        color("aqua") {
            translate([0, 0, height - 5]) {
                difference() {
                    cube([side, side, 5]);
                    translate([side/2, side/2, 0.1]) {
                        cylinder(d=holeDiam, h=6, $fn=50);
                    }
                }
            }
            translate([0, 0, zOffset])
            linear_extrude(height = height - zOffset - 5, center = false, convexity = 10, scale=side*200)
            square(size = .01, center = true);
        }
        translate([-side, -side, 0])
        cube([side, side, height]);
        translate([-side, 0, 0])
        cube([side, side, height]);
        translate([0, -side, 0])
        cube([side, side, height]);
    }
}