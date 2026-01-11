/*
 * SplitDelta - Core logic using MLFeed to calculate split deltas
 */

namespace SplitDelta {
    // Track previous checkpoint delta to calculate split delta
    int previousDelta = 0;
    int currentSplitDelta = 0;
    uint lastCpCount = 0;
    bool hasNewSplitDelta = false;
    
    // PB ghost checkpoint times
    array<int> pbCheckpointTimes;
    uint pbFinishTime = 0;
    uint lastBestTime = 0;  // Track the last known PB to detect when it changes
    
    void Main() {}
    
    void Update() {
        auto app = GetApp();
        
        // Not in a valid race state
        if (app.RootMap is null || app.CurrentPlayground is null) {
            Reset();
            return;
        }
        
        // Get race data from MLFeed
        auto raceData = MLFeed::GetRaceData_V4();
        auto player = raceData.GetPlayer_V4(MLFeed::LocalPlayersName);
        if (player is null) return;
        
        // Check if we hit a new checkpoint
        uint currentCpCount = player.CpCount;
        
        // Detect run restart (CpCount goes back to 0)
        if (currentCpCount < lastCpCount) {
            previousDelta = 0;
        }
        
        if (currentCpCount > lastCpCount && currentCpCount > 0) {
            OnCheckpointCrossed(player, currentCpCount);
        }
        lastCpCount = currentCpCount;
        
        // Load PB times if we don't have them yet OR if the PB has been updated
        if (player.BestTime > 0 && (pbCheckpointTimes.Length == 0 || uint(player.BestTime) != lastBestTime)) {
            LoadPBTimes(player);
            lastBestTime = player.BestTime;
        }
        
        // Detect finish to guarantee PB update within current session
        auto playground = cast<CSmArenaClient>(app.CurrentPlayground);
        if (playground is null) return;
        auto sequence = playground.GameTerminals[0].UISequence_Current;
        if (sequence == CGamePlaygroundUIConfig::EUISequence::Finish) {
            Reset();
        }
    }
    
    void OnCheckpointCrossed(const MLFeed::PlayerCpInfo_V4@ player, uint cpIndex) {
        // Get current race time (total time since run start)
        int currentCpTime = player.cpTimes[cpIndex];

        // Need PB times to compare
        if (pbCheckpointTimes.Length == 0 || pbCheckpointTimes.Length < cpIndex) {
            hasNewSplitDelta = false;
            previousDelta = 0;
            return;
        }
        
        // Get PB checkpoint time
        int pbCpTime = pbCheckpointTimes[cpIndex - 1];
        
        // Calculate current delta (positive = slower than PB, negative = faster than PB)
        int currentDelta = currentCpTime - pbCpTime;
        
        // Calculate split delta (change in delta from previous checkpoint)
        // SKIP the first checkpoint - we don't show split delta for CP1
        if (cpIndex == 1) {
            previousDelta = currentDelta;
            hasNewSplitDelta = false;
            return;
        }
        
        // For CP2+: calculate the change in delta
        currentSplitDelta = currentDelta - previousDelta;
        
        // Update for next checkpoint
        previousDelta = currentDelta;
        hasNewSplitDelta = true;
        
        // Trigger GUI display
        GUI::ShowSplitDelta(currentSplitDelta);
    }
    
    void LoadPBTimes(const MLFeed::PlayerCpInfo_V4@ player) {
        // Try to get PB times from the player's best race
        if (player.BestRaceTimes.Length > 0) {
            pbCheckpointTimes.Resize(0);
            for (uint i = 0; i < player.BestRaceTimes.Length; i++) {
                pbCheckpointTimes.InsertLast(player.BestRaceTimes[i]);
            }
            pbFinishTime = player.BestTime;
        }
    }
    
    void Reset() {
        previousDelta = 0;
        currentSplitDelta = 0;
        lastCpCount = 0;
        hasNewSplitDelta = false;
        pbCheckpointTimes.Resize(0);
        pbFinishTime = 0;
        lastBestTime = 0;
    }
}
