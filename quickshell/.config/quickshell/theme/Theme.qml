import QtQuick
import QtQml
import Quickshell.Io

import "../core" as Core

Item {
    id: theme

    property var paths
    property var state

    readonly property string paletteName: state ? state.paletteName : "earth"

    Core.Log {
        id: log
    }

    FileView {
        id: tokensFile
        path: paths ? paths.fromTheme("tokens.json") : ""
        blockLoading: true
        watchChanges: true
        onFileChanged: reload()
    }

    FileView {
        id: paletteFile
        path: paths ? paths.fromPalette(paletteName + ".json") : ""
        blockLoading: true
        watchChanges: true
        onFileChanged: reload()
    }

    readonly property var tokens: _safeParse(_readText(tokensFile), {})
    readonly property var palette: _safeParse(_readText(paletteFile), {})

    function token(pathArr, fallback) {
        return _get(tokens, pathArr, fallback);
    }

    function color(name, fallback) {
        const def = _get(tokens, ["colors", name], null);

        if (typeof def === "string") {
            if (def.startsWith("palette.")) {
                const key = def.slice("palette.".length);
                return palette?.[key] ?? (fallback ?? "#ff00ff");
            }
            return def;
        }

        if (palette && typeof palette[name] === "string")
            return palette[name];
        return fallback ?? "#ff00ff";
    }

    function space(size, fallback) {
        const v = _get(tokens, ["spacing", size], null);
        return (typeof v === "number") ? v : (fallback ?? 0);
    }

    function radius(size, fallback) {
        const v = _get(tokens, ["radius", size], null);
        return (typeof v === "number") ? v : (fallback ?? 0);
    }

    function fontFamily() {
        return _get(tokens, ["typography", "fontFamily"], "Sans Serif");
    }

    function fontSize() {
        return _get(tokens, ["typography", "fontSize"], 13);
    }

    function _readText(fileView) {
        if (!fileView)
            return "";
        const t = fileView.text;
        if (typeof t === "function")
            return t.call(fileView);
        return (typeof t === "string") ? t : "";
    }

    function _safeParse(text, fallback) {
        try {
            if (!text || typeof text !== "string" || text.trim().length === 0)
                return fallback;
            return JSON.parse(text);
        } catch (e) {
            log.error("[Theme] JSON parse error:", e);
            return fallback;
        }
    }

    function _get(obj, pathArr, fallback) {
        let cur = obj;
        for (let i = 0; i < pathArr.length; i++) {
            if (cur == null)
                return fallback;
            cur = cur[pathArr[i]];
        }
        return (cur === undefined) ? fallback : cur;
    }
}
