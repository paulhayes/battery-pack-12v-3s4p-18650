use <utils.scad>;

h=110;
w=72;
d=65;
r=2;
t=2;
screw_offset=4;
screw_d=1.8;
mid_h = 30;
bw=37.8;
bd=58.8;
bh=1.6;
bsw=31.8;
bsd=52.8;
busbx=7.5;
board_pillar_h = 6;
b2w = 32;
b2d = 60;
b2sw= 21;
b2sx = 7;
b2sd = 20;


module charging_board_2(){
    
    linear_extrude(bh) difference(){
        square([b2w,b2d]);
        for(x=[b2sx:b2sw:b2w]){
            for(y=[0:b2sd:b2d]){
                translate([x,y]) circle(d=2,$fn=48);
            }
        }
    }
    for(y=[5.5:11+9:b2d]){
        translate([b2w,9/2+y,bh]) rotate([0,0,90]) usb();
    }
}

module pillar(){
    difference(){ 
        circle(d=4,$fn=48);
        circle(d=screw_d,$fn=48);
    }
}

module board_2_pillars(){
    linear_extrude(board_pillar_h) {
        for(x=[b2sx:b2sw:b2w]){
            for(y=[0:b2sd:b2d]){
                translate([x,y]) difference(){ 
                    pillar();
                }
            }
        }
    }
}

module charging_board(){
    offset = ( [bw,bd]-[bsw,bsd] )/2;
    /*
    linear_extrude(bh) difference(){
        rounded_rect([bw,bd],2,$fn=48);    
        
        for(x = [offset[0],bw-offset[0]]){
            for(y = [offset[1],bd-offset[1]]){
                translate([x,y]) difference(){
                    circle(d=2,$fn=48);
                }
            }
        }
    }
    */
    translate([busbx+9/2,0,bh]) usb();
}

module board_pillars(){
    offset = ( [bw,bd]-[bsw,bsd] )/2;
    linear_extrude(board_pillar_h){       
        for(x = [offset[0],bw-offset[0]]){
            for(y = [offset[1],bd-offset[1]]){
                translate([x,y]) pillar();
            }
        }
    }
}

module usb(){
    translate([0,-1.2-t,3.3/2]) rotate([-90,0,0]) linear_extrude(7.5+t) offset(0.2) rounded_rect([9,3.3],3.3/2,$fn=48,center=true);
}

module box(){
    difference(){
        linear_extrude(h) difference(){
            rounded_rect([w+2*t,d+2*t],r+t,$fn=48,center=true);
            rounded_rect([w,d],r,$fn=48,center=true);
        }
        for(z=[screw_offset,h-screw_offset]){
            four_screws(z);
        }
    }
}

module four_screws(z){
    for(x=[-w/4,w/4]){
        for(y=[-d/2-t,d/2+t]){
            rotX=sign(y)*90;
            translate([x,y,z]) rotate([rotX,0,0]) self_tap_screw();
            
        }
    }
}

module lid(depth){
    translate([0,0,-depth])linear_extrude(depth) difference(){
        rounded_rect([w,d],r,$fn=48,center=true);
        rounded_rect([w-2*t,d-2*t],r-t+1,$fn=48,center=true);
    }
    translate([0,0,0]) linear_extrude(t) rounded_rect([w+2*t,d+2*t],r+t,$fn=48,center=true);
}

module lidTop(){
    difference(){
        lid(screw_offset*1.5);
        four_screws(-screw_offset);        
    }
}

module lidTopShort(){
    translate([0,0,10+t+h]) lid(1);
}

module lidBottom(){
    translate([0,0,0]) rotate([180,0,0]) difference(){
        lid(screw_offset*1.5);
        four_screws(-screw_offset);
    }
}

module middle(){
    //bottom
    translate([0,0,0]) difference(){
        lid(screw_offset*1.5);
        four_screws(-screw_offset);
        linear_extrude(t) translate([3,0]) rounded_rect([4,8],2,center=true);
    }
    
    //top
    translate([0,0,t]) difference(){        
        linear_extrude(mid_h) difference(){
            rounded_rect([w+2*t,d+2*t],r+t,$fn=48,center=true);
            rounded_rect([w,d],r,$fn=48,center=true);
        };   
        four_screws(mid_h-screw_offset);
        translate([-w/2,-d/2,board_pillar_h]) charging_board();
        translate([w/2-b2w,-b2d/2,board_pillar_h]) charging_board_2();
    }
    //translate([w/2-b2w,-b2d/2,board_pillar_h+t]) charging_board_2();
    translate([w/2-b2w,-b2d/2,t]) board_2_pillars();
    translate([-w/2,-d/2,t]) board_pillars();
}

color([1,1,1]) box();
color([0.1,0.1,0.1]) translate([0,0,h]) middle();
color([1,1,1]) translate([0,0,h+mid_h+t]) lidTop();

//charging_board();
//translate([0,0,mid_h]) lidTopTop();
color([0.1,0.1,0.1]) lidBottom();