import app from "ags/gtk4/app"
import style from "./Bar/Main.scss"
import Bar from "./Bar/Main"

app.start({
  css: style,
  gtkTheme: "adw-gtk3",
  main() {
    app.get_monitors().map(Bar)
  },
})
