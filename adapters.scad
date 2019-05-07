
include <antFarm.scad>;


alienHeight = z; // 19.5;
alienThick = 2.6;
alienSmall = 23.7;
alienLarge = 24.5;

//alienToXav(alienLarge, 2, 1);  // For new alien modules
//alienToXav(alienSmall, 2, 1);  // For old alien modules
//alienShutter(alienSmall);  // For old alien modules


module alienToXav(alienMaxWidth, spacing, type = 0) {
    difference() {

        union() {
            difference() {
                closableJoin(spacing, type);
                translate([-30, -spacing - 7.5, 0]) {
                    cube([60, 5, z]);
                }
                if(type == 0) {
                    translate([16.5, 35, -6])
                        rotate([0, 0, 30])
                            cylinder(d=8, h=20, $fn=6);
                }
            }
            translate([-alienMaxWidth/2, -spacing - 2.5, 0])
                alienShutter(alienMaxWidth);
        }
        if(type == 0) {
            translate([0, -10, 6])
                rotate([-80, 0, 0])
                    cylinder(d=9, h=20, $fn=6);
        } else {
            translate([-doorSquareOpeningWidth/2, -10, 2])
                rotate([10, 0, 0])
                    squareDoorOpening(20);
        }
    }

}

module alienShutter(alienMaxWidth) {
    difference() {
        cube([alienMaxWidth, alienThick, alienHeight]);
        rotate([0, 0, 45])
        cube([5, 5, alienHeight + 1]);

        translate([alienMaxWidth, 0, 0])
        rotate([0, 0, 45])
        cube([5, 5, alienHeight + 1]);
    }
}

alienToAlien();

module alienToAlien() {
    spacer = 3;
    spacerWidth = 18;
    diamOpening = 8;

    difference() {
        union() {
            alienShutter(alienLarge);

            translate([23.7 + 0.4, spacer + 2*alienThick, 0])
                rotate([0, 0, 180])
                    alienShutter(alienSmall);

            translate([(alienLarge - spacerWidth)/2, alienThick, 0])
                cube([spacerWidth, spacer, alienHeight]);
        }
        // door slot
        translate([(alienLarge - doorWidth)/2 - tol, (doorThick + alienThick), 2]) {
            cube([doorWidth + 3*tol, doorThick + 3*tol, z]);
        }
        translate([alienLarge/2, -1, diamOpening/2 + 2.5])
            rotate([-90, 0, 0])
                cylinder(d=diamOpening, h=spacer + 2*alienThick + 2, $fn=6);
    }
}