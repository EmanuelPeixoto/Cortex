import { For, createBinding } from "ags"
import Hyprland from "gi://AstalHyprland";

export default function Workspaces() {
  const hypr = Hyprland.get_default();

  const sortedWorkspaces = createBinding(hypr, "workspaces", (wss) =>
    [...wss].sort((a, b) => a.id - b.id)
  );

  const focused = createBinding(hypr, "focusedWorkspace");

  return (
    <box>
      <For each={sortedWorkspaces}>
        {(ws) => (
          <button
            class={focused.as((fw) => (fw === ws ? "focused" : ""))}
            onClicked={() => ws.focus()}
          >
            {`${ws.id}`}
          </button>
        )}
      </For>
    </box>
  );
}
