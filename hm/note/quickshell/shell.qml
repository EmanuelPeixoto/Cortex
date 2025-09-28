import QtQuick
import Quickshell
import Quickshell.Hyprland
import "bar" as Status

ShellRoot {
  id: root

  Status.Bar {
    id: topbar
  }

  Component.onCompleted: {
    Globals.reloadColors();
  }

  Runner {
    id: launcher
  }
}
