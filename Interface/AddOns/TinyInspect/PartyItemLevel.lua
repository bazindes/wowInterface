local _, LibItem = ...local members, numMembers = {}, 0--計算並廣播隊伍裝備等級local function BroadcastPartyItemLevel()    local total = select(2, GetAverageItemLevel())    local maxLevel, minLevel = total, total    local count = 1    for _, level in pairs(members) do        total = total + level        count = count + 1        if (level > maxLevel) then            maxLevel = level        end        if (level < minLevel) then            minLevel = level        end    end    table.wipe(members)    if (IsInGroup(LE_PARTY_CATEGORY_INSTANCE)) then        SendChatMessage(format("<%s:%.1f> max:%d min:%d", PARTY..STAT_AVERAGE_ITEM_LEVEL, total/count, maxLevel, minLevel), "INSTANCE_CHAT")    else        SendChatMessage(format("<%s:%.1f> max:%d min:%d", PARTY..STAT_AVERAGE_ITEM_LEVEL, total/count, maxLevel, minLevel), "PARTY")    endend--(隊列)讀取隊友裝備等級function GetPartyItemLevel(id)    local unit = "party" .. id    local guid = UnitGUID(unit)    if (not guid or members[guid] or not CanInspect(unit)) then return end    NotifyInspect(unit)    LibItem:AddTask({        identity  = guid,        elasped   = 0.5,        expired   = GetTime() + 4,        onTimeout = function(self) table.wipe(members) end,        onExecute = function(self)            local unknownCount, equippedLevel = LibItem:GetUnitItemLevel(unit)            if (unknownCount == 0 and equippedLevel > 0) then                members[self.identity] = equippedLevel                if (UnitExists("party"..(id+1))) then                    GetPartyItemLevel(id+1)                else                    BroadcastPartyItemLevel()                end                return true            end        end,    })end--隊友增加時才處理local frame = CreateFrame("Frame", nil, UIParent)frame:RegisterEvent("GROUP_ROSTER_UPDATE")frame:SetScript("OnEvent", function(self, event, ...)    if (event == "GROUP_ROSTER_UPDATE" and not IsInRaid()) then        local numCurrent = GetNumSubgroupMembers()        if (numCurrent ~= numMembers) then            if (numCurrent > numMembers) then                --隊伍成立瞬間,部分隊友顯示是離綫,所以要用Task模式                LibItem:AddTask({                    identity  = "AllUnitIsConnected",                    elasped   = 1,                    begined   = GetTime() + 2,                    expired   = GetTime() + 16,                    onExecute = function(self)                        local done = true                        for i = 1, numCurrent do                            if (not UnitIsConnected("party"..i)) then                                done = false                                break                            end                        end                        if (done) then                            GetPartyItemLevel(1)                            return true                        end                    end,                })            end            numMembers = GetNumSubgroupMembers()        end    endend)