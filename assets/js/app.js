// Phoenix LiveView
import "phoenix_html"

import {Socket} from "phoenix"
import {LiveSocket} from "phoenix_live_view"
import topbar from "../vendor/topbar"

topbar.config({barColors: {0: "#4a4db5"}, shadowColor: "rgba(0, 0, 0, .3)"})
window.addEventListener("phx:page-loading-start", info => topbar.show())
window.addEventListener("phx:page-loading-stop", info => topbar.hide())
let Hooks = {}

// Menu on mobile
document.querySelector(".mobile-menu-button").addEventListener("click", () => {
	document.querySelector(".mobile-menu").classList.toggle("hidden");
});

// New post modal

Hooks.NewPostButton = {
	mounted() {
		this.el.addEventListener("click", () => {
			document.querySelector(".new-post-modal").style.height = '250px';
			document.querySelector(".new-post-btn").style.display = 'none';
		});
	}
};
Hooks.NewPostSubmit = {
	mounted() {
		this.el.addEventListener("click", () => {
			document.querySelector(".new-post-form-body").value = "";
			document.querySelector(".new-post-form-title").value = "";
			document.querySelector(".new-post-form").dispatchEvent(
				new Event("submit", {bubbles: true})
			);
		});
	}
};
Hooks.NewPostCancel = {
	mounted() {
		this.el.addEventListener("click", () => {
			document.querySelector(".new-post-modal").style.height = '0px';
			document.querySelector(".new-post-btn").style.display = 'block';
		});
	}
};

let csrfToken = document.querySelector("meta[name='csrf-token']").getAttribute("content")
let liveSocket = new LiveSocket("/live", Socket, {hooks: Hooks, params: {_csrf_token: csrfToken}})

liveSocket.connect()
window.liveSocket = liveSocket