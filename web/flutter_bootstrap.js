{{flutter_js}}
{{flutter_build_config}}

// CanvasKit is served from this site rather than Google's CDN, so the demo
// also loads on networks where gstatic.com is slow or blocked.
_flutter.loader.load({
  config: { canvasKitBaseUrl: "canvaskit/" },
  onEntrypointLoaded: async (engineInitializer) => {
    const appRunner = await engineInitializer.initializeEngine();
    await appRunner.runApp();
    const splash = document.getElementById("splash");
    if (splash) {
      splash.style.opacity = "0";
      setTimeout(() => splash.remove(), 400);
    }
  },
});
