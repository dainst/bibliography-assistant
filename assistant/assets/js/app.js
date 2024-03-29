// We need to import the CSS so that webpack will load it.
// The MiniCssExtractPlugin is used to separate it out into
// its own CSS file.
import "../css/app.scss"

// webpack automatically bundles all modules in your
// entry points. Those entry points can be configured
// in "webpack.config.js".
//
// Import deps with the dep name or local files with a relative path, for example:
//
//     import {Socket} from "phoenix"
//     import socket from "./socket"
//
import "phoenix_html"
import {Socket} from "phoenix"
import {LiveSocket} from "phoenix_live_view"
import topbar from "topbar"

function langIsNotDe() {
  return Array.isArray(navigator.languages)
    && navigator.languages.length > 0
    && !navigator.languages[0].toLowerCase().startsWith("de")
}

const getLang = () => langIsNotDe() ? "en" : "de"

const hooks = {}
hooks.MainHook = {
  mounted() {
    this.handleEvent("request_language", _ => {
      this.pushEvent("select_language", getLang())
    })
  }
}
hooks.CorrespondenceListHook = {
  mounted() {
    this.handleEvent("select", ({idx}) =>
      this.el.querySelector("div:first-of-type").scrollIntoView()
    )
  }
}
hooks.ParserResultListHook = {
  mounted() {
    this.handleEvent("select_item", ({ idx: idx}) => {
      this.el.querySelector(`#parser-result-item-${idx}`).scrollIntoView({
        behavior: 'auto',
        block: 'center',
        inline: 'center'
    })
    })
  }
}
hooks.ZenonResultListHook = {
  mounted() {
    this.handleEvent("select", ({idx}) =>
      this.el.querySelector("div:first-of-type").scrollIntoView()
    )
  }
}

let csrfToken = document.querySelector("meta[name='csrf-token']").getAttribute("content")
let liveSocket = new LiveSocket("/live", Socket, {
  hooks: hooks,
  params: {
    _csrf_token: csrfToken
  }
})

// Show progress bar on live navigation and form submits
topbar.config({barColors: {0: "#29d"}, shadowColor: "rgba(0, 0, 0, .3)"})
window.addEventListener("phx:page-loading-start", info => topbar.show())
window.addEventListener("phx:page-loading-stop", info => topbar.hide())

// connect if there are any LiveViews on the page
liveSocket.connect()

// expose liveSocket on window for web console debug logs and latency simulation:
// >> liveSocket.enableDebug()
// >> liveSocket.enableLatencySim(1000)  // enabled for duration of browser session
// >> liveSocket.disableLatencySim()
window.liveSocket = liveSocket


