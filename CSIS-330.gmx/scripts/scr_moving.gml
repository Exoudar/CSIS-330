///scr_moving();

switch (state) {
    // LEFT
    case 'moving_left':
        // I will explain for left only. Right should be the same
        // If we are moving left, then our x goes to the left based on our self_speed (-= self_speed)
        x -= self_speed;
        // I tried to make this kinda Turn Based (when you are moving left, you can do nothing untill you go back to idle)
        movement_tracking -= self_speed;
        if movement_tracking <= 0 {
            previous_state = 'moving_left';
            state = 'idle';
            movement_tracking = max_movement_per_command;
        }
        break;
    case 'pushing_left': 
        // Here we define "crate" as the movable object left of us
        // then we also ONLY allow it to move if nothing is blocking its path.
        var crate = instance_place(x-1,y,obj_crate);
        // We assume we can move, unless something blocked our path
        var can_move = true; 
        // with: a command to control another (example: from player we move a crate next to it)
        with (crate) {
            // We make sure that crate (the object we are pushing) has nothing blocking its path (wall or another crate)
            if !place_meeting(x-1,y,obj_solid){
                // we make sure this happens once, so we dont counter a problem (moving indefinitely)
                if state != 'moving_left'{
                    state = 'moving_left';
                    previous_state = 'idle';
                    movement_tracking = max_movement_per_command
                }
                
            } else {
                // If there IS something blocking its path, then we are not allowed to move
                can_move = false;
            }
        }
        // In case we are pushing (a movable object is left of us)
        // we move left similar to moving_left, except now we also push the movable object left with us
        if (can_move){
            x -= self_speed;
            movement_tracking -= self_speed;
            if movement_tracking <= 0 {
                previous_state = 'pushing_left';
                state = 'idle';
                movement_tracking = max_movement_per_command
            }
        } else {
            previous_state = 'pushing_left';
            state = 'idle';
            movement_tracking = max_movement_per_command;
        }
        break;
    case 'sliding_left':
        if place_meeting(x-1,y,obj_crate) {
            // if the object is movable, look at its state
            var crate = instance_place(x-1,y,obj_crate); // defining "crate" as the movable object left of us
            
            // Based on crate's states, we either can slide with it, or get stuck if crate can no longer moves
            if crate.state == 'idle' || crate.state == 'stuck'{
                state = 'stuck';
                previous_state = 'sliding_left';
                movement_tracking = max_movement_per_command
            } else if crate.state == 'hold' {
                state = 'hold';
                previous_state = 'sliding_left';
                movement_tracking = max_movement_per_command
            }
            var player = self;
            var can_move = true;
            with (crate) {
                if place_meeting(x,y+1,obj_ice){
                    can_move = true;
                    state = 'sliding_left';
                    movement_tracking = max_movement_per_command
                } else if !place_meeting(x,y+1,obj_solid){
                    can_move = 'false';
                    state = 'falling';
                    previous_state = 'sliding_left';
                    player.state = 'hold';
                } else {
                    can_move = 'false';
                    state = 'idle';
                    previous_state = 'sliding_left';
                    movement_tracking = max_movement_per_command
                }
            }
            if crate.state == 'idle'{
                state = 'stuck';
                movement_tracking = max_movement_per_command;
            }
        }       
        // Here we are sliding and we should take away control from the player
        // untill he stops sliding
        // We make sure while sliding, nothing is infront of us so we dont get stuck
        if !place_meeting(x-1,y,obj_solid){
            if state == 'sliding_left'{
                x -= self_speed;
            }
            movement_tracking -= self_speed;
        }        
        if movement_tracking <= 0 {
            state = 'idle';
            previous_state = 'sliding_left';
            movement_tracking = max_movement_per_command
            // ONLY give back control when the player stopped sliding
            if !place_meeting(x,y+1,obj_ice) && place_meeting(x,y+1,obj_solid){
                state = 'idle';
            }
            // also, if the player hit something, he should stop
            // except now the player is frozen (stuck) and can no longer push anything
            
            // First check if the object is immovable
            if place_meeting(x-1,y,obj_wall){
                state = 'stuck';
            }
        }
        break;
        case 'hold':
            movement_tracking -= self_speed;
            if movement_tracking <= 0 {
                state = previous_state;
                movement_tracking = max_movement_per_command;
            }
            break;
    // RIGHT
    case 'moving_right':
        x += self_speed;
        movement_tracking -= self_speed;
        if movement_tracking <= 0 {
            previous_state = 'moving_right';
            state = 'idle';
            movement_tracking = max_movement_per_command;
        }
        break;
    case 'pushing_right': 
        var crate = instance_place(x+1,y,obj_crate);
        var can_move = true; 
        with (crate) {
            if !place_meeting(x+1,y,obj_solid){
                if state != 'moving_right'{
                    state = 'moving_right';
                    previous_state = 'idle';
                    movement_tracking = max_movement_per_command
                }
            } else {
                can_move = false;
            }
        }
        if (can_move){
            x += self_speed;
            movement_tracking -= self_speed;
            if movement_tracking <= 0 {
                previous_state = 'pushing_right';
                state = 'idle';
                movement_tracking = max_movement_per_command
            }
        } else {
            previous_state = 'pushing_right';
            state = 'idle';
            movement_tracking = max_movement_per_command;
        }
        break;
    case 'sliding_right':
        if place_meeting(x+1,y,obj_crate) {
            var crate = instance_place(x+1,y,obj_crate);
            if crate.state == 'idle' || crate.state == 'stuck'{
                state = 'stuck';
                previous_state = 'sliding_right';
                movement_tracking = max_movement_per_command
            } else if crate.state == 'hold' {
                state = 'hold';
                previous_state = 'sliding_right';
                movement_tracking = max_movement_per_command
            }
            var player = self;
            var can_move = true;
            with (crate) {
                if place_meeting(x,y+1,obj_ice){
                    can_move = true;
                    state = 'sliding_right';
                    movement_tracking = max_movement_per_command
                } else if !place_meeting(x,y+1,obj_solid){
                    can_move = 'false';
                    state = 'falling';
                    previous_state = 'sliding_right';
                    player.state = 'hold';
                } else {
                    can_move = 'false';
                    state = 'idle';
                    previous_state = 'sliding_right';
                    movement_tracking = max_movement_per_command
                }
            }
            if crate.state == 'idle'{
                state = 'stuck';
                movement_tracking = max_movement_per_command;
            }
        }       
        if !place_meeting(x+1,y,obj_solid){
            if state == 'sliding_right'{
                x += self_speed;
            }
            movement_tracking -= self_speed;
        }        
        if movement_tracking <= 0 {
            state = 'idle';
            previous_state = 'sliding_right';
            movement_tracking = max_movement_per_command
            if !place_meeting(x,y+1,obj_ice){
                state = 'idle';
            }
            if place_meeting(x+1,y,obj_wall){
                state = 'stuck';
            }
        }
        break;
    // UP
    case 'climbing_up':
        y -= self_speed;
        movement_tracking -= self_speed;
        if movement_tracking <= 0 {
            previous_state = 'climbing_up';
            state = 'idle';
            movement_tracking = max_movement_per_command
        }
        break;
    // DOWN
    case 'climbing_down':
        y += self_speed;
        movement_tracking -= self_speed;
        if movement_tracking <= 0 {
            previous_state = 'climbing_down';
            state = 'idle';
            movement_tracking = max_movement_per_command
        }
        break;
        
    // GRAVITY
    case 'falling':
        y += self_speed;
        movement_tracking -= self_speed;
        if movement_tracking <= 0 {
            state = 'idle';
            movement_tracking = max_movement_per_command
        }
        break;
}
