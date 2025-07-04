import app from "ags/gtk4/app"
import Astal from "gi://Astal?version=4.0"
import Gdk from "gi://Gdk?version=4.0"
import Audio from "./modules/Audio.tsx"
import Battery from "./modules/Battery.tsx"
import Mpris from "./modules/Mpris.tsx"
import Tray from "./modules/Tray.tsx"
import Clock from "./modules/Clock.tsx"
import Wireless from "./modules/Wireless.tsx"
import Workspaces from "./modules/Workspaces.tsx"

export default function Bar(gdkmonitor: Gdk.Monitor) {
  const { BOTTOM, LEFT, RIGHT } = Astal.WindowAnchor

  return (
    <window
      visible
      name="bar"
      gdkmonitor={gdkmonitor}
      exclusivity={Astal.Exclusivity.EXCLUSIVE}
      anchor={ BOTTOM | LEFT | RIGHT }
      application={app}
    >
      <centerbox>
        <box $type="start">
          <Workspaces />
        </box>
        <box $type="center">
          <Mpris />
        </box>
        <box $type="end">
          <Tray />
          <Wireless />
          <Audio />
          <Battery />
          <Clock />
        </box>
      </centerbox>
    </window>
  )
}
