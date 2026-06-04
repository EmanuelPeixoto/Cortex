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
      searchProcess.running = true
    }
  }
    id: searchProcess
    running: false
    command: [Globals.homeDir + "/.config/quickshell/services/scripts/search.sh", root.searchTerm]
    onRunningChanged: {
      if (!running) console.log("search: process finished")
    }
    stderr: SplitParser {
      onRead: d => { if (d.trim()) console.warn("search stderr:", d.trim()) }
    }
  }
}
