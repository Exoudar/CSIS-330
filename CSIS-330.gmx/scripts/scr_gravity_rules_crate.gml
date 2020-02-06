///scr_gravity_rules_crate();

// If nothing is below us, then we should fall
if !place_meeting(x,y+1,obj_solid) && state == 'idle'{
    // Crates are allowed to move on top of a ladder, but not inside it
    if !place_meeting(x,y+sprite_height,obj_ladder){
        state = 'falling';
    }
}
