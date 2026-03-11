# Quickshell Architecture

Updated from the uploaded project snapshot on **March 8, 2026**.

This document reflects the code that exists in the zip right now, not the planned end state.

## Overview

The current shell is organized around a small, clean stack:

**Core paths/logging → config state → theme resolution → runtime services → UI primitives → widgets → app composition → `shell.qml` root**

At the moment, the only implemented app is the **top bar**, rendered once per detected screen. The launcher and settings panel folders exist, but they are placeholders.

## Current Project Structure

```text
quickshell/
├── .vscode/
│   └── tasks.json
├── apps/
│   ├── bar/
│   │   ├── Bar.qml
│   │   ├── BarLeft.qml
│   │   ├── BarCenter.qml
│   │   ├── BarRight.qml
│   │   └── Styles.qml
│   ├── launcher/
│   │   └── Launcher.qml              # placeholder
│   └── panels/
│       └── SettingsPanel.qml         # placeholder
├── assets/
│   ├── fonts/
│   ├── icons/
│   └── wallpapers/
├── components/
│   ├── primitives/
│   │   ├── Badge.qml                 # TODO placeholder
│   │   ├── Button.qml                # TODO placeholder
│   │   ├── Clickable.qml
│   │   ├── Icon.qml
│   │   ├── IconText.qml
│   │   ├── Label.qml
│   │   ├── MenuItem.qml              # TODO placeholder
│   │   ├── Pill.qml
│   │   ├── ProgressBar.qml           # TODO placeholder
│   │   ├── SectionColumn.qml
│   │   ├── SectionRow.qml
│   │   ├── Separator.qml
│   │   ├── Spacer.qml
│   │   ├── Surface.qml
│   │   └── Tooltip.qml               # TODO placeholder
│   └── widgets/
│       ├── DateTime.qml
│       ├── Media.qml                 # TODO placeholder
│       ├── NetStatus.qml
│       ├── PacmanUpdates.qml
│       ├── Volume.qml
│       ├── WindowTitle.qml
│       ├── WorkspaceDot.qml
│       └── Workspaces.qml
├── config/
│   ├── defaults.jsonc
│   ├── features.jsonc
│   └── keybinds.jsonc
├── core/
│   ├── Log.qml
│   └── Paths.qml
├── docs/
│   └── architecture.md
├── services/
│   ├── DateTime.qml
│   ├── Hyprland.qml
│   ├── Network.qml
│   ├── PacmanUpdates.qml
│   ├── State.qml
│   └── Volume.qml
├── theme/
│   ├── palettes/
│   │   ├── earth.json
│   │   └── mountain.json
│   ├── Theme.qml
│   └── tokens.json
├── quickshell.conf
└── shell.qml
```

## Runtime Composition

`shell.qml` is the runtime entry point.

It does four main things:

1. Creates `Core.Paths`
2. Creates `Services.State` and injects `paths`
3. Creates `Theme.Theme` and injects both `paths` and `state`
4. Iterates `Quickshell.screens` and creates one `apps/bar/Bar.qml` per screen

That means the runtime tree is effectively:

```text
ShellRoot
├── Core.Paths
├── Services.State
├── Theme.Theme
└── Variants(Quickshell.screens)
    └── apps/bar/Bar.qml
```

This shell is already **multi-monitor aware**. Every screen gets its own bar instance, and widgets can decide whether to render on that screen by checking `visibleOn` in config.

## Architectural Layers

## 1. Core

**Location:** `core/`

### `Paths.qml`

`Paths.qml` is the central path resolver for the shell.

It exposes:

- `root` from `Quickshell.shellDir`
- `configDir`
- `themeDir`
- `paletteDir`
- `assetsDir`

It also provides path helpers:

- `join(a, b)`
- `fromRoot(rel)`
- `fromConfig(rel)`
- `fromTheme(rel)`
- `fromPalette(filename)`

This keeps path logic out of services and widgets.

### `Log.qml`

`Log.qml` is a small logging helper. It is no longer a stub.

It provides:

- `info(scope, message)`
- `warn(scope, message)`
- `error(scope, message)`
- `debug(scope, message)`
- optional `debugEnabled`

`State.qml` and `Theme.qml` both use it for parse-error reporting.

### Current role of the Core layer

Right now, core is intentionally light. It is mainly:

- path resolution
- light logging support

It is not yet a broad utilities layer.

## 2. Configuration and Shared State

**Location:** `services/State.qml` + `config/*.jsonc`

`State.qml` is the shell's shared configuration store.

It watches these files with `FileView`:

- `config/defaults.jsonc`
- `config/features.jsonc`
- `config/keybinds.jsonc`

Each file is loaded with:

- `blockLoading: true`
- `watchChanges: true`
- `onFileChanged: reload()`

### What `State.qml` exposes

Parsed top-level values:

- `settings`
- `features`
- `keybinds`

Derived values:

- `paletteName`
- `barEnabled`
- `launcherEnabled`

Helpers/signals:

- `configsReloaded()`
- `reloadAll()`

### Important behavior

`State.qml` supports **JSONC**, not just raw JSON. It strips:

- `// line comments`
- `/* block comments */`

before parsing.

That is important because `defaults.jsonc` already contains inline comments, such as the pacman widget options.

### Architectural role

Despite the name, `State.qml` is really acting as a:

- config loader
- shared state store
- feature toggle source
- runtime settings provider

This means widgets should keep reading from `stateObj` instead of hardcoding values.

## 3. Theme System

**Location:** `theme/`

The theme system is split into:

- `tokens.json`
- palette files under `theme/palettes/`
- `Theme.qml`

### `Theme.qml`

`Theme.qml` watches:

- `theme/tokens.json`
- `theme/palettes/<paletteName>.json`

where `paletteName` comes from `state.paletteName`.

It exposes helper methods instead of raw styling constants:

- `color(name, fallback)`
- `space(size, fallback)`
- `radius(size, fallback)`
- `fontFamily()`
- `fontSize()`

### How color resolution works

`color(name, fallback)` resolves values in this order:

1. Look up `tokens.colors[name]`
2. If the token is a string like `palette.accent`, resolve the key from the active palette
3. If the token is a literal color string, use it directly
4. If the token is missing, fall back to `palette[name]`
5. If still missing, use the provided fallback or `#ff00ff`

That means tokens can either:

- point to palette values
- define direct colors
- fall back gracefully

### Current theme direction

The theme system is now clearly intended to be the global source of:

- colors
- spacing
- radius
- typography

App-specific style helpers should wrap it rather than replace it.

## 4. App-Level Styling

**Location:** `apps/bar/Styles.qml`

This file is new compared with the earlier architecture.

`Styles.qml` acts as a thin bar-specific styling layer on top of the global theme. It provides semantic helpers such as:

- `bg(themeObj)`
- `fg(themeObj)`
- `muted(themeObj)`
- `primary(themeObj)`
- `secondary(themeObj)`
- `accent(themeObj)`
- `success(themeObj)`
- `danger(themeObj)`
- `warning(themeObj)`
- `info(themeObj)`
- `radius(stateObj)`
- `widgetRadius(themeObj)`
- `gap(themeObj)`
- `padX(themeObj)`
- `padY(themeObj)`

### Architectural significance

This establishes a good pattern:

- **global theme** owns tokens and palette resolution
- **app styles** provide semantic aliases and local overrides

So the bar can evolve its own look without bypassing the global token system.

## 5. Services

**Location:** `services/`

The service layer currently contains one config/state service and five runtime services.

### `State.qml`

Already covered above. This is the config/state store.

### `DateTime.qml`

A small local service that formats the current date/time for display.

It provides:

- `now`
- `showSeconds`
- `separator`
- `formattedDate`
- `formattedTime`
- `text`

Behavior:

- updates on a `Timer`
- uses a faster interval when seconds are enabled
- formats date as full weekday + month + day
- formats time as 12-hour AM/PM

### `Hyprland.qml`

Thin wrapper over `Quickshell.Hyprland`.

It exposes:

- `monitor`
- `workspaces`
- `focusedWorkspace`
- `activeToplevel`
- `activeTitle`

It also provides helpers:

- `workspaceById(id)`
- `activateWorkspaceId(id)`

On startup it refreshes:

- monitors
- workspaces
- toplevels

This service is currently used by the workspace widgets and is clearly the bridge into compositor-specific behavior.

### `Network.qml`

Network state service backed by shell commands via `Quickshell.Io.Process`.

It polls every 5 seconds and runs `nmcli` commands to derive:

- `transport` (`offline`, `wifi`, `ethernet`)
- `connected`
- `hasInternet`
- `status`
- `icon`

This service intentionally returns normalized UI-friendly values instead of leaking `nmcli` output into widgets.

### `PacmanUpdates.qml`

Package update service backed by shell commands.

It supports:

- `checkupdates` for repo packages
- optional AUR counts via `paru` or `yay`

It exposes:

- `pacmanCount`
- `aurCount`
- `totalCount`
- `hasUpdates`
- `icon`

It polls on a configurable interval, defaulting to 30 minutes.

### `Volume.qml`

Volume service backed by `wpctl`.

It exposes:

- `value`
- `percent`
- `muted`
- `icon`

It also provides mutating actions:

- `refresh()`
- `toggleMute()`
- `increase()`
- `decrease()`

It polls every 2 seconds and uses separate `Process` instances for querying and mutations.

### Current service design pattern

The runtime services are following a solid pattern:

- wrap OS/compositor commands or APIs
- normalize output into simple QML properties
- keep formatting and polling concerns inside the service
- expose small action methods to widgets

That keeps widgets mostly declarative.

## 6. UI Primitives

**Location:** `components/primitives/`

The primitives layer is partially implemented.

### Implemented primitives

#### `Clickable.qml`

General interaction wrapper.

Provides:

- hover/press state
- click, double click, press-and-hold
- wheel up/down
- enter/exit
- cursor customization
- default content slot

This is the interaction base for widgets like volume and workspace dots.

#### `Label.qml`

Base text primitive that pulls typography defaults from the theme.

Supports:

- theme-aware color
- size
- family
- weight
- optional monospace mode
- right elision

#### `Icon.qml`

Small wrapper over `Label.qml` for Nerd Font icon rendering.

#### `IconText.qml`

Reusable row for icon + label pairs.

#### `Pill.qml`

Rounded bordered container with centered content and theme-driven defaults.

This is currently one of the most important primitives because many widgets use pill presentation.

#### `Surface.qml`

General rounded container with padding and border.

This is more generic than `Pill.qml` and looks intended for larger panels later.

#### `SectionRow.qml` / `SectionColumn.qml`

Spacing-aware layout wrappers using theme spacing.

#### `Separator.qml`

Simple themed separator that can be vertical or horizontal.

#### `Spacer.qml`

Small explicit spacer item.

### Placeholders still present

These files still exist only as `// TODO` placeholders:

- `Badge.qml`
- `Button.qml`
- `MenuItem.qml`
- `ProgressBar.qml`
- `Tooltip.qml`

### Primitive layer role

The primitive layer is now real enough to matter. It is no longer just aspirational.

The main design pattern is:

- keep visuals small and reusable
- derive defaults from the theme
- use primitives as the building blocks for widgets

## 7. Widgets

**Location:** `components/widgets/`

The widget layer is where service data and primitives get combined into actual UI blocks.

### Common widget pattern

Most widgets now follow the same structure:

- receive `stateObj`, `themeObj`, and `screenObj`
- read widget config from `stateObj.settings.widgets.<widgetName>`
- compute `visibleOn`
- gate visibility by monitor name
- optionally render in a pill via `showPill`
- expose width/height through a `Loader`

That is a good standardization pattern and worth preserving.

### Implemented widgets

#### `DateTime.qml`

- uses `Services.DateTime`
- displays the formatted date/time string
- supports pill or bare rendering
- obeys `visibleOn`

#### `PacmanUpdates.qml`

- uses `Services.PacmanUpdates`
- supports AUR inclusion
- supports `labelMode` of `total` or `split`
- hides itself when there are no updates
- obeys `visibleOn`

#### `NetStatus.qml`

- uses `Services.Network`
- can show icon only or icon + status text
- obeys `visibleOn`

#### `Volume.qml`

- uses `Services.Volume`
- supports click-to-mute
- supports wheel up/down for volume changes
- can show icon only or icon + percentage/mute label
- obeys `visibleOn`

#### `Workspaces.qml`

- uses `Services.Hyprland`
- maps screen -> Hyprland monitor -> configured workspace list
- reads workspaces from `settings.workspaces.byMonitor`
- renders each entry through `WorkspaceDot.qml`
- can render as pill or bare row
- obeys `visibleOn`

#### `WorkspaceDot.qml`

- resolves workspace state from `hyprService.workspaceById()`
- displays active and occupied state visually
- activates a workspace when clicked

#### `WindowTitle.qml`

- currently accepts a `title` prop directly
- supports pill or bare rendering
- supports `visibleOn`

This widget exists but is not currently mounted in the bar.

### Placeholder widget

- `Media.qml` is still only `// TODO`

### Widget layer role

The widget layer is now the main composition boundary for:

- service data
- config-driven behavior
- per-monitor visibility
- primitive-based presentation

That is the right place for most feature growth.

## 8. Bar App

**Location:** `apps/bar/`

The bar is the only active app right now.

### `Bar.qml`

`Bar.qml` creates a `PanelWindow` per screen.

It is responsible for:

- binding to the screen passed through `modelData`
- using `stateObj.barEnabled` for visibility
- anchoring to top/left/right
- setting `exclusiveZone` equal to bar height
- reading margins, padding, height, opacity, border width, and radius from config/theme
- creating the styled background rectangle
- mounting left, center, and right sections

### `BarLeft.qml`

Currently just an empty `RowLayout` container.

It is implemented structurally, but no widgets are mounted yet.

### `BarCenter.qml`

Currently contains:

- `Widgets.Workspaces`

### `BarRight.qml`

Currently contains, in order:

- `Widgets.PacmanUpdates`
- `Widgets.Volume`
- `Widgets.NetStatus`
- `Widgets.DateTime`

### Current bar composition

So the actual active bar contents are:

```text
Left:   [empty]
Center: [workspaces]
Right:  [pacman updates] [volume] [network] [date/time]
```

## 9. Configuration Shape

**Location:** `config/defaults.jsonc`, `features.jsonc`, `keybinds.jsonc`

### `defaults.jsonc`

Current responsibilities include:

- active theme palette selection
- top-level UI border width
- bar sizing and spacing
- per-widget settings
- per-monitor workspace lists

Notable configured behavior right now:

- palette defaults to `earth`
- bar is enabled
- bar height is `48`
- workspaces are split across:
  - `DP-1`: workspaces `1-10`
  - `HDMI-A-1`: workspaces `11-13`
- several right-side widgets are only visible on `DP-1`
- workspaces are visible on both `DP-1` and `HDMI-A-1`

### `features.jsonc`

Current feature toggles include:

- `bar: true`
- `launcher: true`
- `settingsPanel: false`
- `osd: false`
- `notifications: true`

Integration flags include:

- `hyprland`
- `mpris`
- `network`
- `audio`
- `power`

Not all of these are wired into implemented features yet.

### `keybinds.jsonc`

Current keybind groups:

- `global`
- `media`

Defined actions include:

- toggle launcher
- reload shell
- volume up
- volume down
- mute toggle

At the moment, keybinds are **declared in config** but there is no visible runtime keybind-binding layer in the uploaded code. So this is configuration that anticipates a future implementation.

## 10. Implemented vs Placeholder Areas

### Implemented now

- root shell composition
- multi-monitor bar instantiation
- config loading from JSONC
- dynamic theme token + palette loading
- bar-specific style helpers
- logging helper
- Hyprland workspace integration
- volume polling and control
- network polling
- pacman/AUR update polling
- date/time formatting
- reusable pill/text/icon/clickable primitives
- workspaces widget
- volume widget
- network widget
- pacman updates widget
- date/time widget
- window title widget file

### Present but not wired in yet

- `WindowTitle.qml` widget
- `launcher` app placeholder
- `SettingsPanel` app placeholder
- many primitive placeholders
- `Media.qml` widget placeholder
- feature flags and keybind definitions beyond current runtime use

## 11. Current Design Patterns Worth Preserving

### Shared object injection

Most composed pieces accept:

- `stateObj`
- `themeObj`
- `screenObj`

This is simple and clear. It keeps dependencies explicit.

### Config-driven per-monitor visibility

Widgets consistently use `visibleOn` lists keyed by monitor name.

That is one of the strongest current patterns in the codebase.

### Service-backed widgets

Widgets mostly avoid shelling out or compositor access directly. They talk to services.

That separation is good and should continue.

### Theme indirection + app-local semantics

The combination of:

- `theme/Theme.qml`
- `apps/bar/Styles.qml`

is the right direction for styling. Theme owns raw tokens; the app layer owns semantic usage.

### Loader-based pill/bare rendering

Multiple widgets support the same content rendered either:

- inside a `Primitive.Pill`
- as bare text/icon content

That makes styling flexible without duplicating business logic.

## 12. Current Gaps and Next Logical Extensions

These are the most obvious next steps implied by the current architecture:

1. Add a real left-side bar composition, likely window title, launcher trigger, media, or system indicators.
2. Add a runtime keybind layer that consumes `keybinds.jsonc`.
3. Implement launcher and settings panel apps behind existing feature toggles.
4. Expand primitives such as `Button`, `Tooltip`, `MenuItem`, and `ProgressBar` once more interactive surfaces exist.
5. Add a real media service/widget path for MPRIS, since the config already signals that direction.
6. Consider moving more bar constants from `Styles.qml` into theme tokens if they become broadly shared across apps.

## 13. Bottom Line

The project is no longer just a rough skeleton. The current state is a **working, structured shell foundation** with:

- centralized config loading
- live theme resolution
- a real service layer
- reusable primitives
- standardized widget composition
- a functioning multi-monitor top bar

The architecture is now clearly moving toward:

- **global token-driven theming**
- **app-local semantic style wrappers**
- **service-backed widgets**
- **config-driven composition and visibility**

That is a solid base to grow from.
