import { bind } from "astal";
import Wp from "gi://AstalWp";

export default function Audio() {
  const speaker = Wp.get_default()?.audio?.defaultSpeaker;
  if (!speaker) return null;

  return (
    <box className="Audio">
      <icon icon={bind(speaker, "volumeIcon")} />
      <label label={bind(speaker, "volume").as((p) => `${Math.floor(p * 100)}%`)} />
    </box>
  );
}
