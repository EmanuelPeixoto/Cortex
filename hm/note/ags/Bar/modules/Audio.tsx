import { bind } from "astal";
import Wp from "gi://AstalWp";
import GLib from "gi://GLib";

export default function Audio() {
  const speaker = Wp.get_default()?.audio?.defaultSpeaker;
  if (!speaker) return null;

  const handleClick = () => {
    try {
      GLib.spawn_command_line_async("pwvucontrol");
    } catch (error) {
      console.error("Erro ao abrir o pwvucontrol:", error);
    }
  };

  const handleScroll = (_, event) => {
    const step = 0.02;
    const direction = event.delta_y > 0 ? -step : step;
    const newVolume = speaker.volume + direction;
    speaker.volume = Math.max(0, Math.min(1.25, newVolume));
  };

  return (
    <eventbox onScroll={handleScroll} onClick={handleClick}>
      <box className="Audio">
        <icon icon={bind(speaker, "volumeIcon")} />
        <label label={bind(speaker, "volume").as((p) => `${Math.floor(p * 100)}%`)} />
      </box>
    </eventbox>
  );
}
