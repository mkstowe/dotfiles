import QtQml

QtObject {
    id: root

    property bool debugEnabled: true

    function _prefix(scope) {
        return scope ? "[" + scope + "]" : "[Shell]"
    }

    function info(scope, message) {
        console.log(_prefix(scope), message)
    }

    function warn(scope, message) {
        console.warn(_prefix(scope), message)
    }

    function error(scope, message) {
        console.error(_prefix(scope), message)
    }

    function debug(scope, message) {
        if (debugEnabled)
            console.log(_prefix(scope), message)
    }
}