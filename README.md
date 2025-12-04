# Split Deltas Plugin for Trackmania

An Openplanet plugin that displays the **split delta** between consecutive checkpoints in Trackmania 2020.

## What is a Split Delta?

A split delta shows how much time you gained or lost in a segment (between two consecutive checkpoints) compared to your PB.

**Example:**
- At checkpoint 1: You're -50ms vs PB (50ms ahead)
- At checkpoint 2: You're -150ms vs PB (150ms ahead)
- **Split Delta: -100ms** (you gained 100ms in that segment!)

Note: The first checkpoint doesn't show a split delta since there's no previous segment to compare.

## Features

- **Split Delta Display**: Shows time gained/lost in each segment vs your PB
- **Color Coding**: 
  - Green: Gained time in that segment (faster than PB)
  - Red: Lost time in that segment (slower than PB)
  - Gray: About the same pace
- **Customizable UI**: Adjust position, size, colors, and display duration
- **Styled like split-speeds**: Familiar look and feel

## How It Works

1. Plugin loads your PB checkpoint times using MLFeed API
2. As you cross each checkpoint, it calculates your current delta vs PB
3. It compares your current delta to the previous checkpoint's delta
4. The difference (split delta) is displayed with color coding

## Settings

Access settings via Openplanet menu (F3 → Plugins → Split Deltas → Settings):

**UI:**
- Display duration (how long to show after each checkpoint)
- UI scale
- Anchor X/Y position (adjust to position next to checkpoint splits)
- Colors (faster/slower/text)
- Native TM colors (blue/red instead of green/orange)
- Text shadow
- Show when GUI is hidden

## Installation

1. Install [Openplanet](https://openplanet.dev/)
2. Copy this plugin folder to your Openplanet plugins directory
3. The plugin will automatically load (requires MLFeed dependency)

## File Structure

- `src/Main.as` - Entry point
- `src/SplitDelta.as` - Core logic using MLFeed API
- `src/GUI.as` - Rendering overlay
- `src/Settings.as` - User settings
- `Oswald-Regular.ttf` - Font file
- `info.toml` - Plugin metadata

## Credits

Inspired by [tm-split-speeds](https://github.com/RuurdBijlsma/openplanet-split-speeds) by RuteNL