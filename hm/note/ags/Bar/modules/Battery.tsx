import Gtk from "gi://Gtk?version=4.0"
import AstalBattery from "gi://AstalBattery"
import { createBinding } from "ags"

export default function Battery() {
  const battery = AstalBattery.get_default()

  const percent = createBinding(
    battery,
    "percentage",
  )((p) => `${Math.floor(p * 100)}%`)

  const chargeLabel = createBinding(
    battery,
    "percentage",
  )((p) => `Carga: ${Math.floor(p * 100)}%`)

  const batteryStatus = createBinding(battery, "state")((state) => {
    switch (state) {
      case 0: return "Status: Desconhecido"
      case 1: return "Status: Carregando"
      case 2: return "Status: Descarregando"
      case 3: return "Status: Vazio"
      case 4: return "Status: Carregado"
      case 5: return "Status: Pendente (Carregamento)"
      case 6: return "Status: Pendente (Descarregamento)"
      default: return `Status: ${state}`
    }
  })

  // Tempo restante para carregar ou descarregar
  const timeRemaining = createBinding(battery, "timeToEmpty")((time) => {
    if (time <= 0) return "Tempo: Calculando..."

    const hours = Math.floor(time / 3600)
    const minutes = Math.floor((time % 3600) / 60)

    if (hours > 0) {
      return `Tempo: ${hours}h ${minutes}m`
    } else {
      return `Tempo: ${minutes}m`
    }
  })

  const chargingRate = createBinding(battery, "energyRate")((rate) => {
    if (rate === 0) return "Potência: 0W"
    return `Potência: ${rate.toFixed(1)}W`
  })

  const batteryCapacity = createBinding(battery, "energy")((energy) => {
    if (energy === 0) return "Energia: N/A"
    return `Energia: ${energy.toFixed(1)}Wh`
  })

  return (
    <menubutton visible={createBinding(battery, "isPresent")}>
      <box>
        <image iconName={createBinding(battery, "iconName")} />
        <label label={percent} />
      </box>
      <popover>
        <box orientation={Gtk.Orientation.VERTICAL} spacing={8}>
          <box orientation={Gtk.Orientation.VERTICAL}>
            <label label="Informações da Bateria" xalign={0} />
            <Gtk.Separator />
            <label label={chargeLabel} xalign={0} />
            <label label={batteryStatus} xalign={0} />
            <label label={timeRemaining} xalign={0} />
            <label label={chargingRate} xalign={0} />
            <label label={batteryCapacity} xalign={0} />
          </box>
        </box>
      </popover>
    </menubutton>
  )
}
