import QtQml 
import Quickshell 

QtObject {
  id: paths

  // Root folder of this config (the folder containing shell.qml)
  readonly property string root: Quickshell.shellDir

  // Common directories inside the shell
  readonly property string configDir: root + "/config"
  readonly property string themeDir: root + "/theme"
  readonly property string paletteDir: themeDir + "/palettes"
  readonly property string assetsDir: root + "/assets"

  function join(a, b) {
    if (!a || a.length === 0) return b
    if (!b || b.length === 0) return a
    if (a.endsWith("/")) return a + (b.startsWith("/") ? b.slice(1) : b)
    return a + (b.startsWith("/") ? b : ("/" + b))
  }

  function fromRoot(rel) {
    // supports rel like "config/defaults.json"
    return join(root, rel)
  }

  function fromConfig(rel) {
    return join(configDir, rel)
  }

  function fromTheme(rel) {
    return join(themeDir, rel)
  }

  function fromPalette(filename) {
    return join(paletteDir, filename)
  }
}