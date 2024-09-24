#region Spawn Animation Logic
if (is_spawning) {
    sprite_index = spr_spawn;
    image_speed = 1;

    if (image_index >= image_number - 1) is_spawning = false;
}
#endregion