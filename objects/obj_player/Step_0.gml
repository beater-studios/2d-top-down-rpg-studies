// If you are running spawn animation then block functions
if (is_spawning) return;

#region Keyboard Inputs
var _move_left = keyboard_check(vk_left) || keyboard_check(ord("A"));
var _move_right = keyboard_check(vk_right) || keyboard_check(ord("D"));
var _move_up = keyboard_check(vk_up) || keyboard_check(ord("W"));
var _move_down = keyboard_check(vk_down) || keyboard_check(ord("S"));
#endregion 

#region Identifying Movement
var _is_moving = (_move_left || _move_right || _move_up || _move_down);
var _is_moving_vertical = (_move_up || _move_down);
var _is_moving_horizontal = (_move_left || _move_right);
var _is_running = _is_moving && keyboard_check(vk_shift);
#endregion

#region Delta Time Calculation
var _delta_time = delta_time / 1000000;
#endregion

#region Rolling Logic
if (keyboard_check_pressed(vk_control) && !is_rolling) {
	is_rolling = true;
	roll_timer = roll_duration;
	sprite_index = spr_roll;
	image_index = 0;
	image_speed= 0;
}

if (is_rolling) {
	roll_timer -= _delta_time;
	
	var _frame = floor((1 - (roll_timer / roll_duration)) * sprite_get_number(spr_roll));
    image_index = clamp(_frame, 0, sprite_get_number(spr_roll) - 1);

	if (roll_timer > 0) {
		x += (image_xscale * roll_speed) * _delta_time;
		return;
	} else {
        is_rolling = false;
        sprite_index = spr_idle;
		image_speed= 1;
    }
}
#endregion

#region Jump Logic
if (keyboard_check_pressed(vk_space) && !is_jumping) {
	is_jumping = true;
    jump_timer = _is_moving ? jump_duration_moving : jump_duration_idle;
    sprite_index = spr_jump;
	image_index = _is_moving ? 1 : 0;
	// TODO: jump more while pressing the button?
	image_speed = 0;
}

if (is_jumping) {
	// Update jump sprite frame if movement state changes
    image_index = _is_moving ? 1 : 0;
    jump_timer -= _delta_time;

    if (jump_timer <= 0) {
        is_jumping = false;
        sprite_index = spr_idle;
		image_speed = 1;
    }
}
#endregion

#region Calculation of Speed ​​and Acceleration
// Setting target speed based on whether you are running or not
var _target_speed = _is_running ? speed_run : speed_walk;

// Determining horizontal and vertical direction
var _x_dir = _move_right - _move_left;
var _y_dir = _move_down - _move_up;

// Vary acceleration when walking or running
var _accel_plus_running = _is_running ? 7 : 2.5;

// Smooth movement with acceleration for movement
if (_x_dir != 0) hspd = approach(hspd, _x_dir * _target_speed, _accel_plus_running);
if (_y_dir != 0) vspd = approach(vspd, _y_dir * _target_speed, _accel_plus_running);

// Applying character speed
x += hspd * _delta_time;
y += vspd * _delta_time;
#endregion

#region Deceleration Calculation
// Vary deceleration when walking or running
var _decel_plus_running = _is_running ? 175 : 275;

// Smooth deceleration when changing direction of movement
if (_x_dir == 0) hspd = approach(hspd, 0, _decel_plus_running);
if (_y_dir == 0) vspd = approach(vspd, 0, _decel_plus_running);
#endregion

// Changing sprite direction based on side
image_xscale = _x_dir != 0 ? _x_dir : image_xscale;	

if (is_jumping) return; 

if (_is_moving) {
	// Changing the sprite based on whether it is moving
	sprite_index = spr_walk;
		
	if (_is_running) {
		// Adjusts dust frequency based on running speed
		var _dust_rate = clamp(1.0 - abs(hspd) / speed_run, 0.5, 1);
		dust_spawn_interval = _dust_rate * 0.2;

		// Increments the timer
		dust_timer += _delta_time;

		// Check if it's time to create dust
		if (dust_timer >= dust_spawn_interval) {
			var _sprite_dust = _is_moving_vertical ? spr_dust_run_up : spr_dust_run;
		    var _dust = instance_create_layer(x, y, "Instances", obj_dust_run, {
				sprite_index: _sprite_dust
			});
		    _dust.x -= sign(_x_dir) * sprite_get_width(spr_walk) * 0.5;
		    _dust.image_xscale = sign(hspd) ? sign(hspd) : image_xscale * -1;
        
		    // Reset the timer
		    dust_timer = 0;
		}
	} else {
		// Reset timer if character is not running
		dust_timer = 0
	}
} else {
	sprite_index = spr_idle;
}
