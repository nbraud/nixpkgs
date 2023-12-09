{ lib
, callPackage
, config
, newScope
}:

lib.makeScope newScope (self:
  let inherit (self) callPackage;
  in {
    inherit (callPackage ./mpv.nix { }) acompressor autocrop autodeint autoload;
    inherit (callPackage ./occivink.nix { }) blacklistExtensions seekTo;

    buildLua = callPackage ./buildLua.nix { };
    chapterskip = callPackage ./chapterskip.nix { };
    convert = callPackage ./convert.nix { };
    inhibit-gnome = callPackage ./inhibit-gnome.nix { };
    mpris = callPackage ./mpris.nix { };
    mpv-playlistmanager = callPackage ./mpv-playlistmanager.nix { };
    mpv-webm = callPackage ./mpv-webm.nix { };
    mpvacious = callPackage ./mpvacious.nix { };
    quality-menu = callPackage ./quality-menu.nix { };
    simple-mpv-webui = callPackage ./simple-mpv-webui.nix { };
    sponsorblock = callPackage ./sponsorblock.nix { };
    thumbfast = callPackage ./thumbfast.nix { };
    thumbnail = callPackage ./thumbnail.nix { };
    uosc = callPackage ./uosc.nix { };
    visualizer = callPackage ./visualizer.nix { };
    vr-reversal = callPackage ./vr-reversal.nix { };
    webtorrent-mpv-hook = callPackage ./webtorrent-mpv-hook.nix { };
    cutter = callPackage ./cutter.nix { };

  } // lib.optionalAttrs config.allowAliases {
    youtube-quality = throw "'youtube-quality' is no longer maintained, use 'quality-menu' instead"; # added 2023-07-14
  }
)
