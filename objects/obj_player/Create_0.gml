#region Variables for movement logic
speed_walk = 115;
speed_run = 150;

hspd = 0;
vspd = 0;
#endregion

// Dust spawn timer
dust_timer = 0;

// Initial dust spawn interval
dust_spawn_interval = 0;

// Start player with initial spawn state
is_spawning = true;

#region Variables for Jump Logic
is_jumping = false;
jump_timer = 0;
jump_duration_idle = 0.3;
jump_duration_moving = 0.45;
#endregion

#region Variables for Scrolling Logic
is_rolling = false;
roll_duration = 0.5; // Scroll duration in seconds
roll_timer = 0;
roll_speed = 100; // Movement speed while rolling
#endregion