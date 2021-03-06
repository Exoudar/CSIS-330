///scr_input_keys();

// setting shortcuts for our movement keys
var left = keyboard_check(vk_left);
var right = keyboard_check(vk_right);
var up = keyboard_check(vk_up);
var down = keyboard_check(vk_down);

// ***LEFT COMMAND***

// First we make sure we are in idle state (not moving)
if (left) && state == 'idle' {
    // First, we make sure that one pixel (-1) left of us is not a wall
    if !place_meeting(x-1,y,obj_wall){
        // First lets make sure no crate is blocking our path (in case the crate is falling or moving towards us)
        if place_meeting(x-1,y,obj_crate){
            var crate = instance_place(x-1,y,obj_crate);
            if crate.state == 'idle'{
                state = 'moving_left';
            }
        } else {
            state = 'moving_left';
        }
    }
    
    // If another object is left of us, we are either able to push it or not
    if place_meeting(x-1,y,obj_crate) {
        // We should only be allowed to push something if it was not moving
        var crate = instance_place(x-1,y,obj_crate);
        if crate.state == 'idle'{
            state = 'pushing_left';
        }
    }
}

// RIGHT COMMAND

// First we make sure we are in idle state (not moving)
if (right) && state == 'idle' {
    if !place_meeting(x+1,y,obj_wall){
        if place_meeting(x+1,y,obj_crate){
            var crate = instance_place(x+1,y,obj_crate);
            if crate.state == 'idle'{
                state = 'moving_right';
            }
        } else {
            state = 'moving_right';
        }
    }
    if place_meeting(x+1,y,obj_crate) {
        var crate = instance_place(x+1,y,obj_crate);
        if crate.state == 'idle'{
            state = 'pushing_right';
        }
    }
}

/// UP COMMAND
if (up) && (state == 'idle' || state == 'stuck') {
    // We check if we are inside a ladder so we can climb it.
    // And we also make sure we are idle (not sliding, frozen, stunned,... etc)
    if place_meeting(x,y,obj_ladder){
        // We make sure nothing is blocking our path towards up
        if !place_meeting(x,y-1,obj_solid){
            state = 'climbing_up';
        }
    }
}

/// DOWN COMMAND
if (down) && (state == 'idle'  || state == 'stuck') {
    // We check if we are inside a ladder so we can climb it.
    // And we also make sure we are idle (not sliding, frozen, stunned,... etc)
    // NOTE: we want to also make sure a ladder is under us. Hence, the y+1
    if place_meeting(x,y,obj_ladder) || place_meeting(x,y+1,obj_ladder){
        // We make sure nothing is blocking our path towards up
        if !place_meeting(x,y+1,obj_solid){
            state = 'climbing_down';
        }
    }
}
