///scr_wheel_rules();

// This rule will apply to wheel so they can keep rolling when we push them once.
switch(state) {
    case 'idle':
        // In our idle state, if we're not falling, then keep rolling
        if !falling && rolling{
            state = previous_state;
        }
        // If we fell, once we hit the ground we should turn falling to false and continue rolling
        if place_meeting(x,y+1,obj_solid){
            if falling {
                falling = false;
                if previous_state == 'rolling_left' || previous_state == 'rolling_right'{
                    rolling = true;
                }
            }
        }
        break;
    case 'moving_left':
        x -= self_speed;
        movement_tracking -= self_speed;
        state = 'rolling_left';
        rolling = true;
        break;
    case 'moving_right':
        x += self_speed;
        movement_tracking -= self_speed;
        state = 'rolling_right';
        rolling = true;
        break;
    case 'rolling_left':
        if !place_meeting(x-1,y,obj_solid){
            x -= self_speed;
        }
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
            // Here we apply rolling to another wheel if we collide with it
            if place_meeting(x-1,y,obj_crate){
                if place_meeting(x-1,y,obj_wheel){
                    var wheel = instance_place(x-1,y,obj_wheel);
                    with (wheel){
                        if state != 'falling'{
                            state = 'rolling_left';
                            movement_tracking = max_movement_per_command;
                        }
                    }
                    if wheel.state == 'rolling_right'{
                        state = 'rolling_left';
                        movement_tracking = max_movement_per_command;
                    }
                }
                // To control taffic, we apply hold to ourselves if anothing object is flaling next to us
                var crate = instance_place(x-1,y,obj_crate);
                if crate.state == 'falling'{
                    state = 'hold';
                    previous_state = 'rolling_left';
                    movement_tracking = max_movement_per_command + (max_movement_per_command/8);
                }
            }
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
            falling = true;
        }
        break;
    case 'rolling_right':
        if !place_meeting(x+1,y,obj_solid){
            x += self_speed;
        }
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
            // Here we apply rolling to another wheel if we collide with it
            if place_meeting(x+1,y,obj_crate){
                if place_meeting(x+1,y,obj_wheel){
                    var wheel = instance_place(x+1,y,obj_wheel);
                    with (wheel){
                        if state != 'falling'{
                            state = 'rolling_right';
                            movement_tracking = max_movement_per_command;
                        }
                    }
                    if wheel.state == 'rolling_left'{
                        state = 'rolling_right';
                        movement_tracking = max_movement_per_command;
                    }
                }
                
                // To control taffic, we apply hold to ourselves if anothing object is flaling next to us
                var crate = instance_place(x+1,y,obj_crate);
                if crate.state == 'falling'{
                    state = 'hold';
                    previous_state = 'rolling_right';
                    movement_tracking = max_movement_per_command + (max_movement_per_command/8);
                }
            }
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
            falling = true;
        }
        break;
}
