///scr_wheel_rules();

// This rule will apply to wheel so they can keep rolling when we push them once.
switch(state) {
    case 'idle':
        if previous_state == 'moving_left'{
            if state != 'falling'{
                rolling = true;
                state = 'rolling_left';
                movement_tracking = max_movement_per_command
            }
        } else if previous_state == 'moving_right'{
            if state != 'falling'{
                rolling = true;
                state = 'rolling_right';
                movement_tracking = max_movement_per_command
            }
        }
        break;
    case 'rolling_left':
        x -= self_speed;
        movement_tracking -= self_speed;
        if movement_tracking <= 0 {
            previous_state = 'rolling_left';
            state = 'rolling_left';
            movement_tracking = max_movement_per_command;
        }
        // Apply collision
        if place_meeting(x-1,y,obj_solid){
            rolling = false;
            state = 'idle';
            previous_state = 'rolling_left';
            movement_tracking = max_movement_per_command
            
            // Apply ice rules
            if place_meeting(x,y+1,obj_ice){
                var crate = instance_place(x-1,y,obj_crate);
                with (crate) {
                    if place_meeting(x,y+1,obj_ice){
                        state = 'sliding_left';
                    }
                }
            }
        }
        // Apply gravity
        if !place_meeting(x,y+1,obj_solid) {
            rolling = false;
            state = 'falling';
            previous_state = 'rolling_left';
            movement_tracking = max_movement_per_command
        }
        break;
    case 'rolling_right':
        x += self_speed;
        movement_tracking -= self_speed;
        if movement_tracking <= 0 {
            previous_state = 'rolling_right';
            state = 'rolling_right';
            movement_tracking = max_movement_per_command;
        }
        
        // Apply collision
        if place_meeting(x+1,y,obj_solid){
            rolling = false;
            state = 'idle';
            previous_state = 'rolling_right';
            movement_tracking = max_movement_per_command
            
            // Apply ice rules
            if place_meeting(x,y+1,obj_ice){
                var crate = instance_place(x+1,y,obj_crate);
                with (crate) {
                    if place_meeting(x,y+1,obj_ice){
                        state = 'sliding_right';
                    }
                }
            }
        }
        // Apply gravity
        if !place_meeting(x,y+1,obj_solid) {
            rolling = false;
            state = 'falling';
            previous_state = 'rolling_right';
            movement_tracking = max_movement_per_command
        }
        break;
}

// test

if state == 'idle' && (previous_state == 'rolling_left' || previous_state == 'rolling_right') {
    if place_meeting(x,y+1,obj_solid){
        state = previous_state;
    }
}
