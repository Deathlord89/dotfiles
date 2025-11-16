{
  config,
  lib,
  ...
}:
let
  cfg = config.optional.gaming.mangohud;
in
{
  options.optional.gaming.mangohud = {
    enable = lib.mkEnableOption "Enable Mangohud FPS overlay";
  };

  config = lib.mkIf cfg.enable {
    programs.mangohud = {
      enable = true;
      enableSessionWide = false;
      settings = {
        # 0 means no limit
        #fps_limit = "0,60,141";
        # 1 = vsync off, 3 = vsync on
        vsync = "1";

        legacy_layout = true;
        gpu_stats = true;
        gpu_temp = true;
        gpu_load_change = true;
        gpu_load_value = "50,90";
        gpu_load_color = "8FF0A4,F9F06B,CC0000";
        gpu_text = "GPU";
        cpu_stats = true;
        cpu_temp = true;
        cpu_load_change = true;
        core_load_change = true;
        cpu_load_value = "50,90";
        cpu_load_color = "FFFFFF,FFAA7F,CC0000";
        cpu_color = "99C1F1";
        cpu_text = "CPU";
        io_color = "D8D8D8";
        vram = true;
        vram_color = "F9F06B";
        ram = true;
        ram_color = "FFBE6F";
        fps = true;
        engine_version = true;
        engine_color = "CDAB8F";
        gpu_name = true;
        gpu_color = "4FB830";
        vulkan_driver = true;
        wine = true;
        wine_color = "DC8ADD";
        frame_timing = true;
        frametime_color = "8FF0A4";
        throttling_status = true;
        show_fps_limit = true;
        resolution = true;
        version = "true;";

        # Hide until toggled
        no_display = true;

        position = "top-left";
        #font_size = "38";
        text_color = "D8D8D8";
        background_alpha = "0.8";
        background_color = "020202";
        round_corners = "1";
        table_columns = "3";

        toggle_hud = "Shift_L+F1";
        toggle_fps_limit = "Shift_L+F2";
        #toggle_hud_position = "Shift_L+F2";
        toggle_logging = "Shift_L+F3";
        reload_cfg = "Shift_L+F4";
      };
    };
  };
}
