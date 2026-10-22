{ pkgs, ... }:

let
  profileEppSync = pkgs.writeShellScript "profile-epp-sync" ''
    pp="/sys$DEVPATH/profile"
    [ -z "$DEVPATH" ] && pp="/sys/class/platform-profile/platform-profile-0/profile"
    profile=$(cat "$pp" 2>/dev/null) || exit 0
    case "$profile" in
      low-power)            epp=power ;;
      balanced)             epp=balance_performance ;;
      balanced-performance) epp=performance ;;  # red = Performance
      performance|custom)   epp=performance ;;  # Extreme/Custom
      *)                    exit 0 ;;
    esac
    for p in /sys/devices/system/cpu/cpufreq/policy*/energy_performance_preference; do
      echo "$epp" > "$p" 2>/dev/null
    done
  '';
in
{
  powerManagement.enable = true;

  services.tlp = {
    enable = true;
    settings = {
      # Fn+Q (platform_profile) drives CPU perf via EPP — see udev rule + script below.
      CPU_MAX_PERF_ON_AC = 100;
      CPU_MAX_PERF_ON_BAT = 60;
      CPU_MIN_PERF_ON_AC = 0;
      CPU_MIN_PERF_ON_BAT = 0;

      USB_AUTOSUSPEND = 0;
    };
  };

  # Mirror Fn+Q (platform_profile) to intel_pstate EPP.
  services.udev.extraRules = ''
    SUBSYSTEM=="platform-profile", ACTION=="change", RUN+="${profileEppSync}"
  '';
}
