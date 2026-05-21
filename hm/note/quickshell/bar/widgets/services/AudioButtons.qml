pragma Singleton
import QtQuick
import Quickshell
import Quickshell.Services.Pipewire

Singleton {
  readonly property var sink: Pipewire.defaultAudioSink
  readonly property var source: Pipewire.defaultAudioSource

  readonly property bool sinkMuted: sink?.audio?.muted ?? true
  readonly property real sinkVolume: sink?.audio?.volume ?? 0

  readonly property bool sourceMuted: source?.audio?.muted ?? true
  readonly property real sourceVolume: source?.audio?.volume ?? 0

  property string outputIcon: {
    if (!sink || !sink.audio) return Quickshell.iconPath("audio-volume-muted");
    if (sinkMuted || sinkVolume === 0) return Quickshell.iconPath("audio-volume-muted");
    if (sinkVolume < 0.33) return Quickshell.iconPath("audio-volume-low");
    if (sinkVolume < 0.66) return Quickshell.iconPath("audio-volume-medium");
    if (sinkVolume < 1.0)  return Quickshell.iconPath("audio-volume-high");
    return Quickshell.iconPath("audio-volume-high-danger");
  }

  property string inputIcon: {
    if (!source || !source.audio) return Quickshell.iconPath("microphone-sensitivity-muted");
    if (sourceMuted || sourceVolume === 0) return Quickshell.iconPath("microphone-sensitivity-muted");
    if (sourceVolume < 0.33) return Quickshell.iconPath("microphone-sensitivity-low");
    if (sourceVolume < 0.66) return Quickshell.iconPath("microphone-sensitivity-medium");
    return Quickshell.iconPath("microphone-sensitivity-high");
  }
}
