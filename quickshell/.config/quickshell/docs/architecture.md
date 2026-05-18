# Quickshell Architecture

Last updated for the current repository state (bar + launcher + power menu + screenshot menu + notifications, with service-backed bar widgets).

## 1) Architectural Summary

This shell is organized as layered, modular QML:

1. **Core utilities** (`core/`)
   - path resolution (`Paths.qml`)
   - lightweight logging (`Log.qml`)
2. **Config + state** (`services/State.qml` + `config/*.jsonc`)
   - JSONC parsing + file watching
   - feature gating
   - cross-window UI visibility state
3. **Theme system** (`theme/`)
   - token + palette resolution
   - semantic style surface (`GlobalStyle.qml`)
4. **Runtime services** (`services/`)
   - launcher, notifications, power actions, screenshot actions, media, network, volume, weather, workspaces, updates
5. **UI primitives** (`components/primitives/`)
   - reusable low-level controls (button, pill, badge, separators, layout helpers, etc.)
6. **Feature widgets** (`components/widgets/`)
   - service-connected UI building blocks
7. **App windows** (`apps/*`)
   - screen-bound windows/panels composed from widgets + styles
8. **Root composition** (`shell.qml`)
   - shared singletons
   - per-screen app instantiation

---

## 2) Full Project Map (what exists now)

```text
quickshell/
├── apps/
│   ├── bar/
│   │   ├── Bar.qml
│   │   ├── BarLeft.qml
│   │   ├── BarCenter.qml
│   │   ├── BarRight.qml
│   │   └── Styles.qml
│   ├── launcher/
│   │   ├── Launcher.qml
│   │   └── Styles.qml
│   ├── notifications/
│   │   ├── Popups.qml
│   │   ├── History.qml
│   │   └── Styles.qml
│   ├── powermenu/
│   │   ├── PowerMenu.qml
│   │   └── Styles.qml
│   ├── screenshotmenu/
│   │   ├── ScreenshotMenu.qml
│   │   └── Styles.qml
│   └── panels/
│       └── SettingsPanel.qml            # reserved, not mounted in shell.qml
├── components/
│   ├── primitives/
│   │   ├── Badge.qml
│   │   ├── Button.qml
│   │   ├── Clickable.qml
│   │   ├── Icon.qml
│   │   ├── IconText.qml
│   │   ├── Label.qml
│   │   ├── MenuItem.qml
│   │   ├── Pill.qml
│   │   ├── ProgressBar.qml
│   │   ├── SectionColumn.qml
│   │   ├── SectionRow.qml
│   │   ├── Separator.qml
│   │   ├── Spacer.qml
│   │   ├── Surface.qml
│   │   └── Tooltip.qml
│   └── widgets/
│       ├── LauncherButton.qml
│       ├── LauncherPanel.qml
│       ├── PowerMenuButton.qml
│       ├── PowerMenuPanel.qml
│       ├── ScreenshotMenuButton.qml
│       ├── ScreenshotMenuPanel.qml
│       ├── Notifications.qml
│       ├── NotificationPopupStack.qml
│       ├── NotificationHistoryButton.qml
│       ├── NotificationHistoryPanel.qml
│       ├── DateTime.qml
│       ├── Weather.qml
│       ├── Volume.qml
│       ├── NetStatus.qml
│       ├── Media.qml
│       ├── PacmanUpdates.qml
│       ├── Workspaces.qml
│       ├── WorkspaceDot.qml
│       └── WindowTitle.qml
├── config/
│   ├── defaults.jsonc
│   ├── features.jsonc
│   └── keybinds.jsonc
├── core/
│   ├── Log.qml
│   └── Paths.qml
├── docs/
│   └── architecture.md
├── scripts/
│   ├── launcher_apps.py
│   ├── notifications_dump.py
│   └── media_listener.py
├── services/
│   ├── State.qml
│   ├── Launcher.qml
│   ├── PowerMenu.qml
│   ├── ScreenshotMenu.qml
│   ├── Notifications.qml
│   ├── DateTime.qml
│   ├── Weather.qml
│   ├── Network.qml
│   ├── Volume.qml
│   ├── Media.qml
│   ├── PacmanUpdates.qml
│   └── Hyprland.qml
├── theme/
│   ├── tokens.json
│   ├── Theme.qml
│   ├── GlobalStyle.qml
│   └── palettes/
│       ├── earth.json
│       └── mountain.json
├── quickshell.conf
└── shell.qml
```

---

## 3) Root Runtime Composition (`shell.qml`)

`ShellRoot` creates shared singletons once and app windows per monitor.

### Shared singletons
- `Core.Paths`
- `Services.State`
- `Theme.Theme`
- `Services.Notifications` (`notificationsCenter`)

### Per-screen windows (`Variants { model: Quickshell.screens }`)
For every detected screen:
- `apps/bar/Bar.qml`
- `apps/launcher/Launcher.qml`
- `apps/powermenu/PowerMenu.qml`
- `apps/screenshotmenu/ScreenshotMenu.qml`
- `apps/notifications/Popups.qml`
- `apps/notifications/History.qml`

`apps/panels/SettingsPanel.qml` exists but is not currently instantiated from `shell.qml`.

---

## 4) Core Layer

## `core/Paths.qml`
Canonical path utility object used by services/apps/scripts path resolution:
- shell root
- config/theme/palette/assets directories
- helpers like `fromRoot()`, `fromConfig()`, etc.

## `core/Log.qml`
Minimal logging utility used by config/theme parsing code paths.

---

## 5) Config + State Layer

## `services/State.qml`
This is the centralized state and config loader.

### Responsibilities
- watches and parses:
  - `config/defaults.jsonc`
  - `config/features.jsonc`
  - `config/keybinds.jsonc`
- strips JSONC comments before parse
- exposes `settings`, `features`, `keybinds`
- derives feature-enabled flags (`barEnabled`, `launcherEnabled`, `powerMenuEnabled`, `screenshotMenuEnabled`, `notificationsHistoryEnabled`)
- manages UI panel visibility/toggles:
  - launcher open/screen
  - power menu open/screen
  - screenshot menu open/screen
  - notification history open/screen
- coordinates panel exclusivity in open/toggle helpers

---

## 6) Theme Layer

## `theme/Theme.qml`
Resolves tokenized theme values from:
- `theme/tokens.json`
- selected palette (`theme/palettes/*.json`)

API surface used throughout UI:
- `color(...)`
- `space(...)`
- `radius(...)`
- typography helpers

## `theme/GlobalStyle.qml`
Semantic style mapping (spacing scale, radii, panel/control colors, text colors, etc.) used by app-local `Styles.qml` and widgets.

## App style adapters
- `apps/bar/Styles.qml`
- `apps/launcher/Styles.qml`
- `apps/powermenu/Styles.qml`
- `apps/screenshotmenu/Styles.qml`
- `apps/notifications/Styles.qml`

These keep app-level visual semantics readable while inheriting global theme rules.

---

## 7) Service Layer (domain logic)

## `services/Launcher.qml`
- holds app list/search/filter state
- keyboard selection state
- launch execution
- uses `scripts/launcher_apps.py` for source data

## `services/PowerMenu.qml`
- defines power action model
- resolves configured commands
- executes chosen action

## `services/ScreenshotMenu.qml`
- defines screenshot action model (area, active window, current screen, all screens)
- resolves configured `grimblast` commands or delegates default captures to `scripts/screenshot_capture.sh`, which expands `~`/`$HOME` before invoking `grimblast`
- executes screenshot capture immediately without confirmation

## `services/Notifications.qml`
Notification hub shared across bar and notification windows.

### Responsibilities
- realtime popup ingestion via DBus monitor (`Notify`)
- polling reconciliation using `scripts/notifications_dump.py`
- history list, unread count, popup list
- popup dedupe + expiry
- dismiss single / clear all behavior
- best-effort backend cleanup via `dunstctl`
- suppression of dismissed items to prevent resurrection

## Other runtime services
- `DateTime`, `Weather`, `Network`, `Volume`, `Media`, `PacmanUpdates`, `Hyprland`
- consumed by corresponding bar widgets

---

## 8) Component Layer

## Primitives (`components/primitives`)
Reusable low-level controls for consistency:
- `Button`, `Clickable`, `Pill`, `Badge`, `Icon`, `IconText`, `Label`
- `MenuItem`, `ProgressBar`, `Tooltip`
- layout/surface helpers (`SectionRow`, `SectionColumn`, `Separator`, `Spacer`, `Surface`)

## Widgets (`components/widgets`)
Reusable feature-facing UI composed from primitives + services.

### Launcher widgets
- `LauncherButton.qml`
- `LauncherPanel.qml`

### Power widgets
- `PowerMenuButton.qml`
- `PowerMenuPanel.qml`

### Screenshot widgets
- `ScreenshotMenuButton.qml`
- `ScreenshotMenuPanel.qml`

### Notifications widgets
- `Notifications.qml` (count/icon widget)
- `NotificationPopupStack.qml`
- `NotificationHistoryButton.qml`
- `NotificationHistoryPanel.qml`

### Bar/system widgets
- `DateTime`, `Weather`, `Volume`, `NetStatus`, `Media`, `PacmanUpdates`
- `Workspaces` + `WorkspaceDot`
- `WindowTitle`

---

## 9) App Layer

## `apps/bar`
Persistent top panel shell with three sections:
- left (`BarLeft`) for launcher/menu/media/weather
- center (`BarCenter`) for workspace indicators and active window title
- right (`BarRight`) for updates/notifications/network/volume/datetime

`Bar.qml` dynamically expands total window height when dropdown content (e.g., forecast/calendar panels) is open.

## `apps/launcher`
Full-screen transparent overlay with left-anchored app list/search panel.

## `apps/powermenu`
Bottom-center compact overlay with icon actions + confirmation flow.

## `apps/screenshotmenu`
Bottom-center compact overlay with immediate grimblast actions for area, active window, current screen, and all screens, saving captures into the user's real `~/Pictures/screenshots` directory by default via the helper capture script.

## `apps/notifications`
- `Popups.qml`: transient top-right notification cards
- `History.qml`: top-right history panel with clear/dismiss controls

---

## 10) Scripts Layer

## `scripts/launcher_apps.py`
Enumerates desktop entries, normalizes launcher records, outputs JSON.

## `scripts/notifications_dump.py`
Reads notification history from `dunstctl` (multiple output shapes), normalizes to service schema JSON.

## `scripts/media_listener.py`
Media-related helper for media service integration.

---

## 11) Configuration Model

## `config/defaults.jsonc`
Primary runtime defaults, including:
- bar appearance/layout
- launcher behavior/layout
- power menu behavior/actions
- notifications center (poll interval/realtime/popup/history settings)
- widget-level behavior (date/time/weather/volume/network/media/updates/workspaces)

## `config/features.jsonc`
Feature gates for high-level shell modules (bar, launcher, power menu, notifications, integrations).

## `config/keybinds.jsonc`
Declarative keybind metadata:
- launcher toggle
- power menu toggle
- notification history toggle
- shell reload
- media keys

---

## 12) Data/Control Flow Snapshot

### Launcher
1. bar button or keybind toggles launcher state in `State.qml`
2. launcher app window appears on target screen
3. `services/Launcher.qml` refreshes app list from script + filters by query
4. selection/click launches process and closes launcher

### Power menu
1. bar button or keybind toggles power menu state
2. power menu panel shows actions
3. optional confirmation flow
4. `services/PowerMenu.qml` executes selected command

### Notifications
1. realtime DBus `Notify` events create immediate popups
2. polling reconciles canonical history/count from backend
3. history panel reads shared service state
4. dismiss/clear updates UI state and attempts backend cleanup

---

## 13) Design Intent

The project follows a clear pattern:
- **Services own logic/state**
- **Widgets own reusable UI fragments**
- **Apps own window-level composition**
- **State + config stays centralized**
- **Theme stays token/palette-driven**

This keeps feature development additive and modular while maintaining multi-monitor behavior and consistent styling.
