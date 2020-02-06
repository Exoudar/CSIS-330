///scr_gravity_rules_player();

// If nothing is below us, then we should fall
if !place_meeting(x,y+1,obj_solid) && state == 'idle'{
    if (!place_meeting(x,y,obj_ladder) && !place_meeting(x,y+1,obj_ladder)){
        state = 'falling';
    }
}
