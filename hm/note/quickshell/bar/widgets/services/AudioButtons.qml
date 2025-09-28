pragma Singleton
import QtQuick
import Quickshell
import Quickshell.Services.Pipewire

Singleton {
  property string outputIcon: {
    const sink = Pipewire.defaultAudioSink;
    if (!sink || !sink.audio)
    return Quickshell.iconPath("audio-volume-muted");

    const vol = sink.audio.volume;

    // Volume levels based on user feedback
    if (sink.audio.muted || vol === 0)
    return Quickshell.iconPath("audio-volume-muted");
    if (vol < 0.33)
    return Quickshell.iconPath("audio-volume-low");
    if (vol < 0.66)
    return Quickshell.iconPath("audio-volume-medium");
    if (vol < 1.0)
    return Quickshell.iconPath("audio-volume-high");
    return Quickshell.iconPath("audio-volume-high-danger");
  }

  property string inputIcon: {
    const source = Pipewire.defaultAudioSource;
    if (!source || !source.audio)
    return Quickshell.iconPath("microphone-sensitivity-muted");

    const vol = source.audio.volume;

    if (source.audio.muted || vol === 0)
    return Quickshell.iconPath("microphone-sensitivity-muted");
    if (vol < 0.33)
    return Quickshell.iconPath("microphone-sensitivity-low");
    if (vol < 0.66)
    return Quickshell.iconPath("microphone-sensitivity-medium");
    return Quickshell.iconPath("microphone-sensitivity-high");
  }
}
