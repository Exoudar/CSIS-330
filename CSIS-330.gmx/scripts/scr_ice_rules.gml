///scr_ice_rules(direction);
var direction_ = argument0
// If there is an ice below us, then we go to sliding state
if place_meeting(x,y+1,obj_ice) && state == 'idle'{
    // We will slide in the direction based on our previous state
    switch (previous_state){
        // LEFT SIDE
        case 'sliding_left':
            state = 'sliding_left';
            previous_state = 'sliding_left';
            movement_tracking = max_movement_per_command
            break;
        case 'moving_left':
            state = 'sliding_left';
            previous_state = 'moving_left';
            movement_tracking = max_movement_per_command
                break;
        case 'pushing_left':
            state = 'sliding_left';
            previous_state = 'pushing_left';
            movement_tracking = max_movement_per_command
            break;
        // RIGHT SIDE
        case 'sliding_right':
            state = 'sliding_right';
            previous_state = 'sliding_right';
            movement_tracking = max_movement_per_command
            break;
        case 'moving_right':
            state = 'sliding_right';
            previous_state = 'moving_right';
            movement_tracking = max_movement_per_command
                break;
        case 'pushing_right':
            state = 'sliding_right';
            previous_state = 'pushing_right';
            movement_tracking = max_movement_per_command
            break;
    }
}
