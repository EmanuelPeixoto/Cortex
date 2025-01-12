import { bind } from "astal";
import Network from "gi://AstalNetwork";
import GLib from "gi://GLib";

export default function Wifi() {
  const { wifi } = Network.get_default() || {};

  const handleClick = () => {
    try {
      GLib.spawn_command_line_async("nmtui");
    } catch (error) {
      console.error("Erro ao abrir o nmtui:", error);
    }
  };

  return wifi ? (
    <button class_name="Wifi" onClicked={handleClick}>
      <box>
        <icon icon={bind(wifi, "iconName")} />
        <label label={bind(wifi, "ssid").as(String)} />
      </box>
    </button>
  ) : null;
}
