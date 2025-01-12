import { App } from "astal/gtk3"
import Bar_S from "./Bar/Main.scss"
import Bar from "./Bar/Main"

App.start({
    css: Bar_S,
    instanceName: "js",
    requestHandler(request, res) {
        print(request)
        res("ok")
    },
    main: () => App.get_monitors().map(Bar),
})
