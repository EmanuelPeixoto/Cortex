import { Variable, GLib } from "astal";

export default function Time({ format = "%H:%M" }) {
  const time = Variable("").poll(1000, () => GLib.DateTime.new_now_local().format(format) || "");

  const handleClick = () => {
    try {
      GLib.spawn_command_line_async("ghostty -e \"cal -y && echo Aperte Enter para sair... && read\"");
    } catch (error) {
      console.error("Erro ao abrir o calendário:", error);
    }
  };

  return (
    <button className="Time" onClicked={handleClick} onDestroy={() => time.drop()}>
      <box orientation="horizontal" spacing={5}>
        <icon icon="appointment-soon-symbolic" />
        <label label={time()} />
      </box>
    </button>
  );
}

