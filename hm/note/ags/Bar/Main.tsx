import { Astal, Gtk, Gdk } from "astal/gtk3";
// import Audio from "./modules/Audio.tsx"
import BatteryLevel from "./modules/BatteryLevel.tsx"
import Media from "./modules/Media.tsx"
import SysTray from "./modules/SysTray.tsx"
import Time from "./modules/Time.tsx"
import Wifi from "./modules/Wifi.tsx"
import Workspaces from "./modules/Workspaces.tsx"

export default function Bar(monitor: Gdk.Monitor) {
  const { BOTTOM, LEFT, RIGHT } = Astal.WindowAnchor;

  return (
    <window
      className="Bar"
      gdkmonitor={monitor}
      exclusivity={Astal.Exclusivity.EXCLUSIVE}
      anchor={BOTTOM | LEFT | RIGHT}
    >
      <centerbox>
        <box hexpand halign={Gtk.Align.START}>
          <Workspaces />
        </box>
        <box>
          <Media />
        </box>
        <box hexpand halign={Gtk.Align.END}>
          <SysTray />
          <Audio />
          <Wifi />
          <BatteryLevel />
          <Time />
        </box>
      </centerbox>
    </window>
  );
}

