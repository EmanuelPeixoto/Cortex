import { bind } from "astal";
import { Gtk } from "astal/gtk3";
import Mpris from "gi://AstalMpris";

export default function Media() {
  const mpris = Mpris.get_default();

  return (
    <box className="Media">
      {bind(mpris, "players").as((players) => {
        const player = players[0];
        return player ? (
          <box>
            <box
              className="Cover"
              valign={Gtk.Align.CENTER}
            />
            <label
              label={bind(player, "title").as(() => `${player.title || "Unknown"}`)}
            />
          </box>
        ) : (
            "Nothing Playing"
          );
      })}
    </box>
  );
}
