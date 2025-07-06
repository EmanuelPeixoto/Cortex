import AstalWp from "gi://AstalWp"
import Gtk from "gi://Gtk?version=4.0"
import { createBinding } from "ags"
import { execAsync } from "ags/process"

export default function Audio() {
  const { defaultSpeaker: speaker, defaultMicrophone: microphone } = AstalWp.get_default()!



  return (
    <menubutton
      $={(self) => {
        const gesture = new Gtk.GestureClick()
        gesture.set_button(3)
        gesture.connect('pressed', () => {
          execAsync("pwvucontrol").catch(console.error)
        })
        self.add_controller(gesture)
      }}
    >
      <box>
        <image iconName={createBinding(speaker, "volumeIcon")} />
        <label label={createBinding(speaker, "volume")((vol) => `${Math.round((vol || 0) * 100)}%`)} />
      </box>
      <popover>
        <box orientation="horizontal" spacing={12} css="padding: 8px;">

          <box orientation="vertical" spacing={4} halign="center">
            <label label="Alto-falante" xalign={0} css="font-weight: bold; font-size: 0.9em;" />
            <slider
              widthRequest={100}
              onChangeValue={({ value }) => speaker.set_volume(value)}
              value={createBinding(speaker, "volume")}
            />
            <button
              iconName={createBinding(speaker, "mute")((muted) => muted ? "audio-volume-muted-symbolic" : "audio-volume-high-symbolic")}
              onClicked={() => speaker.set_mute(!speaker.mute)}
              css="min-width: 24px; min-height: 24px;"
            />
            <label label={createBinding(speaker, "volume")((vol) => `${Math.round((vol || 0) * 100)}%`)} xalign={0} css="font-size: 0.8em;" />
          </box>

          <Gtk.Separator orientation="vertical" />

          <box orientation="vertical" spacing={4} halign="center">
            <label label="Microfone" xalign={0} css="font-weight: bold; font-size: 0.9em;" />
            <slider
              widthRequest={100}
              onChangeValue={({ value }) => microphone.set_volume(value)}
              value={createBinding(microphone, "volume")}
            />
            <button
              iconName={createBinding(microphone, "mute")((muted) => muted ? "microphone-sensitivity-muted-symbolic" : "microphone-sensitivity-high-symbolic")}
              onClicked={() => microphone.set_mute(!microphone.mute)}
              css="min-width: 24px; min-height: 24px;"
            />
            <label label={createBinding(microphone, "volume")((vol) => `${Math.round((vol || 0) * 100)}%`)} xalign={0} css="font-size: 0.8em;" />
          </box>

        </box>
      </popover>
    </menubutton>
  )
}
