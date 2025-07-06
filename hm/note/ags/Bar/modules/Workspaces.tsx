import { For, createBinding } from "ags"
import Hyprland from "gi://AstalHyprland";

export default function Workspaces() {
  const hypr = Hyprland.get_default();

  let lastWorkspaceIds = "";
  const workspaces = createBinding(hypr, "workspaces").as(wss => {
    if (!wss?.length) return [];
    const currentIds = wss.map(ws => ws.id).sort((a, b) => a - b).join(",");
    if (currentIds === lastWorkspaceIds) {
      return wss.filter(ws => ws.id > 0).sort((a, b) => a.id - b.id);
    }

    lastWorkspaceIds = currentIds;

    return wss
      .filter(ws => ws.id > 0)
      .sort((a, b) => a.id - b.id);
  });

  const focused = createBinding(hypr, "focusedWorkspace");

  return (
    <box class="Workspaces">
      <For each={workspaces}>
        {(ws) => (
          <button
            class={focused.as(fw => fw === ws ? "focused" : "")}
            onClicked={() => ws.focus()}
          >
            {ws.id}
          </button>
        )}
      </For>
    </box>
  );
}
