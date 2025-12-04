/*
 * Settings - User-configurable plugin settings
 */

[Setting name="Text shadow" category="UI"]
bool textShadow = false;

[Setting name="Show when GUI is hidden" category="UI"]
bool showWhenGuiHidden = false;

[Setting name="Use native TM colours (blue/red)" category="UI"]
bool nativeColours = false;

[Setting color name="Text colour" category="UI"]
vec4 textColour = vec4(1, 1, 1, 1);

[Setting name="Display duration (ms)" min=1000 max=10000 category="UI" description="How long to show the split delta after each checkpoint"]
uint displayDuration = 3000;

[Setting name="UI Scale" min=0.1 max=2 category="UI"]
float scale = 1;

[Setting name="Anchor X position" min=0 max=1 category="UI" description="Horizontal position (0=left, 1=right)"]
float anchorX = .525;

[Setting name="Anchor Y position" min=0 max=1 category="UI" description="Vertical position (0=top, 1=bottom)"]
float anchorY = .328;

[Setting color name="Faster (gained time) colour" category="UI"]
vec4 fasterColour = vec4(0, .63, .12, .75);

[Setting color name="Slower (lost time) colour" category="UI"]
vec4 slowerColour = vec4(1, .5, 0, .75);
