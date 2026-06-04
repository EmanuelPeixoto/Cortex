pragma Singleton
import QtQuick
import Quickshell
import Quickshell.Io
import qs

Singleton {
  id: root
  property string searchTerm: ""

  onSearchTermChanged: {
    if (searchTerm !== "") {
      const q = searchTerm.replace(/[^a-zA-Z0-9 ]/g, "").replace(/ /g, "+")
      searchProcess.command = ["xdg-open", "https://duckduckgo.com/?q=" + q]
      searchProcess.running = true
    }
  }

  Process {
    id: searchProcess
    running: false
    environment: ({
      "DISPLAY": Quickshell.env("DISPLAY") || ":0",
      "WAYLAND_DISPLAY": Quickshell.env("WAYLAND_DISPLAY") || "wayland-1",
      "PATH": Quickshell.env("PATH") || "/run/current-system/sw/bin"
    })
  }
}
