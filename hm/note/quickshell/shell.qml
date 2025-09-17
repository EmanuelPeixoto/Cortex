import QtQuick
import Quickshell
import Quickshell.Hyprland
import "bar" as Status

// import "bar/widgets/services/dock" as Docks

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
