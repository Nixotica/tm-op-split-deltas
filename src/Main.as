void Main() {
    GUI::Main();
    SplitDelta::Main();
}

void Render() {
    GUI::Render();
}

void Update(float dt) {
    SplitDelta::Update();
}

void RenderMenu() {
    if (UI::MenuItem("\\$f70" + Icons::AreaChart + "\\$z Split Deltas", "", GUI::enabled)) {
        GUI::enabled = !GUI::enabled;
    }
}

void OnSettingsChanged() {
    // Show UI for 3 seconds to see effect of settings changes
    GUI::showTime = Time::Now;
}
