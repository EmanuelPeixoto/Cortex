import app from "ags/gtk4/app"
import style from "./Bar/Main.scss"
import Bar from "./Bar/Main"

app.start({
  css: style,
  gtkTheme: "Adwaita",
  main() {
    app.get_monitors().map(Bar)
  },
})
