/*
 * GUI - Renders the split delta overlay (styled like split speeds)
 */

namespace GUI {
    vec4 currentColour = vec4(0, 0, 0, 0);
    vec4 neutralColour = vec4(.5, .5, .5, .75);
    vec4 shadowColour = vec4(0, 0, 0, .6);
    nvg::Font font;

    int shadowX = 1;
    int shadowY = 1;
    int fontSize = 34;

    int splitDelta = 0;
    uint showTime = 0;
    bool visible = false;
    bool enabled = true;
    string splitDeltaText = "";

    void Main() {
        font = nvg::LoadFont("Oswald-Regular.ttf");
    }
    
    void ShowSplitDelta(int delta) {
        splitDelta = delta;
        showTime = Time::Now;
    }

    void Render() {
        // Check if in menu
        auto app = GetApp();
        if (app.RootMap is null || app.CurrentPlayground is null) return;
        
        if (nativeColours) {
            fasterColour = vec4(0, .123, .822, .75);
            slowerColour = vec4(.869, 0.117, 0.117, .784);
        }

        // showTime is when the UI element was shown
        visible = Time::Now < showTime + displayDuration;
        
        // Format delta text with milliseconds
        splitDeltaText = Time::Format(Math::Abs(splitDelta));
        if (splitDelta > 0) {
            splitDeltaText = "+" + splitDeltaText;
        } else if (splitDelta < 0) {
            splitDeltaText = "-" + splitDeltaText;
        } else {
            splitDeltaText = "0";
        }
        
        // Determine color based on split delta (negative = gained time = green)
        if (splitDelta < 0) {  // Gained time (better)
            currentColour = fasterColour;
        } else if (splitDelta > 0) {  // Lost time (worse)
            currentColour = slowerColour;
        } else {  // Exactly 0
            currentColour = neutralColour;
        }

        if (!UI::IsGameUIVisible() && !showWhenGuiHidden) return;
        if (font == 0) return;
        if (!enabled) return;
        if (!visible) return;

        float h = float(Draw::GetHeight());
        float w = float(Draw::GetWidth());
        if (h == 0 || w == 0) return;
        
        float scaleX, scaleY, offsetX = 0;
        if (w / h > 16. / 9) {
            auto correctedW = (h / 9.) * 16;
            scaleX = correctedW / 2560;
            scaleY = h / 1440;
            offsetX = (w - correctedW) / 2;
        } else {
            scaleX = w / 2560;
            scaleY = h / 1440;
        }

        nvg::Save();
        nvg::Translate(offsetX, 0);
        nvg::Scale(scaleX, scaleY);
        RenderDefaultUI();
        nvg::Restore();
    }

    void RenderDefaultUI() {
        // Match split speeds styling
        uint boxHeight = uint(scale * 57);
        uint padding = 7;
        
        nvg::FontFace(font);
        nvg::FontSize(scale * fontSize);
        
        // Measure text width to dynamically size the box
        vec2 textBounds = nvg::TextBounds(splitDeltaText);
        uint boxWidth = uint(textBounds.x + padding * 2 + 10); // Add extra padding for margins
        
        // Position to the right of the checkpoint split display
        uint x = uint(anchorX * 2560);
        uint y = uint(anchorY * 1440 - boxHeight / 2);

        // Draw box
        nvg::BeginPath();
        nvg::Rect(x, y, boxWidth, boxHeight);
        nvg::FillColor(currentColour);
        nvg::Fill();
        nvg::ClosePath();

        // Draw split delta text
        nvg::TextAlign(nvg::Align::Right | nvg::Align::Middle);

        if (textShadow) {
            nvg::FillColor(shadowColour);
            nvg::TextBox(x - padding + shadowX, y + boxHeight / 2 + shadowY + 3, boxWidth, splitDeltaText);
        }
        nvg::FillColor(textColour);
        nvg::TextBox(x - padding, y + boxHeight / 2 + 3, boxWidth, splitDeltaText);
    }
}