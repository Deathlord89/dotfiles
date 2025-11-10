{ pkgs, ... }:
{
  home.packages = with pkgs; [
    mpv-shim-default-shaders
  ];
  programs.mpv = {
    enable = true;
    config = {
      # https://iamscum.wordpress.com/guides/videoplayback-guide/mpv-conf/

      # Profile
      profile = "high-quality"; # Specify high quality video rendering preset

      # General
      cursor-autohide = "100";
      autocreate-playlist = "same";
      keep-open = "yes";

      # OSD
      osd-bar = "no"; # Recommended for uosc
      border = "no"; # Recommended for uosc

      # Priority
      alang = "jpn,ger,eng";
      slang = "ger,eng,enm";

      # Video
      vo = "gpu-next"; # Use experimental GPU renderer.
      gpu-api = "vulkan"; # Use vulkan instead of D3D11
      hwdec = "auto"; # Uses best available hardware decoder.

      # Shader
      glsl-shader = "${pkgs.mpv-shim-default-shaders}/share/mpv-shim-default-shaders/shaders/FSR.glsl";

      # error-diffusion: high-end GPUs
      dither = "error-diffusion";
      dither-depth = "auto";
      error-diffusion = "sierra-lite"; # uncomment if not 'error-diffusion'

      # Deband - Toggle with b
      deband = "no";
      deband-iterations = "2";
      deband-threshold = "32";
      deband-range = "16";
      deband-grain = "0";

      # Interpolation
      video-sync = "display-resample";
      interpolation = "yes";
    };
    scripts = with pkgs.mpvScripts; [
      inhibit-gnome
      mpris
      quality-menu
      sponsorblock-minimal
      thumbfast
      uosc
    ];
  };
}
