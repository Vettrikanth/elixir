import { Socket } from "phoenix"
import { LiveSocket } from "phoenix_live_view"

let Hooks = {}
Hooks.Download = {
  mounted() {
    console.log("Download hook mounted");
    this.handleEvent("download", ({ data, filename }) => {
      try {
        console.log("Received download event:", { data, filename });
        const blob = new Blob([data], { type: "text/csv;charset=utf-8" });
        console.log("Blob created: size=", blob.size);
        const url = window.URL.createObjectURL(blob);
        console.log("URL created:", url);
        const link = document.createElement("a");
        link.href = url;
        link.setAttribute("download", filename || "data.csv");
        document.body.appendChild(link);
        link.click();
        console.log("Link clicked");
        document.body.removeChild(link);
        window.URL.revokeObjectURL(url);
        console.log("Cleanup completed");
      } catch (error) {
        console.error("Download failed:", error.message, error.stack);
      }
    });
  }
}

let csrfToken = document.querySelector("meta[name='csrf-token']").getAttribute("content");
let liveSocket = new LiveSocket("/live", Socket, {
  params: { _csrf_token: csrfToken },
  hooks: Hooks
});
liveSocket.connect();