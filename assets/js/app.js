// Phoenix LiveView
import "phoenix_html"

import {Socket} from "phoenix"
import {LiveSocket} from "phoenix_live_view"
import topbar from "../vendor/topbar"

topbar.config({barColors: {0: "#4a4db5"}, shadowColor: "rgba(0, 0, 0, .3)"})
window.addEventListener("phx:page-loading-start", info => topbar.show())
window.addEventListener("phx:page-loading-stop", info => topbar.hide())

// Menu on mobile
document.querySelector(".mobile-menu-button").addEventListener("click", () => {
	document.querySelector(".mobile-menu").classList.toggle("hidden");
});

let Hooks = [];

Hooks.ScrollToTop = {
	mounted() {
	  this.el.addEventListener("click", e => {
		window.scrollTo(0, 0);
	  })
	}
  }  

Hooks.RestoreFont = {
	mounted() {
	  this.pushEvent("set-font", {
		font: localStorage.getItem("font"),
	  })
	},
  }

let csrfToken = document.querySelector("meta[name='csrf-token']").getAttribute("content")
let liveSocket = new LiveSocket("/live", Socket, {params: {_csrf_token: csrfToken}, hooks: Hooks})

liveSocket.connect()
window.liveSocket = liveSocket