{ ... }:
{
  systemd.user.services.battery-life = {
    Unit = {
      Description = "Disables services to increase battery life";
      BindsTo= ["dev-power_supply_ADP0.device"];
      After= ["dev-power_supply_ADP0.device"];
    };
    Service = {
      ExecStart = "/home/emanuel/Cortex/hm/note/battery.sh";
    };
    Install.WantedBy = ["multi-user.target"];
  };

}
