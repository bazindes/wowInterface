--------------------------------------- 聊天記錄顯示用戶等級-- Author:M-------------------------------------TinyChatLevelDB = {}--清空數據周期(單位為天 0:永不清理)local flushElapsed = 0--最高等級local maxLevel = GetMaxPlayerLevel()--當前語系local locale = GetLocale()--計算下次需要更新的時間點local function nextTimer(level, t)    if (level < 90) then --90以下30分鐘刷新        return t + 1800    elseif (level < 100) then --90-100 2小時刷新        return t + 7200    else        return t + 86400    endend--存儲或更新信息(class暫不用)local function nameFactory(fullname, level, class, forceUpdate)    local t = time()    if (not fullname) then return end    if (not strfind(fullname, "-")) then fullname = fullname.."-"..GetRealmName() end    if (TinyChatLevelDB[fullname] and (TinyChatLevelDB[fullname].t==0 or TinyChatLevelDB[fullname].t > t)) then        --unit總是更新,除非已經滿級        if (forceUpdate and TinyChatLevelDB[fullname].t~=0) then            TinyChatLevelDB[fullname].l = level        end    else        TinyChatLevelDB[fullname] = TinyChatLevelDB[fullname] or {}        TinyChatLevelDB[fullname].l = level        TinyChatLevelDB[fullname].t = level>=maxLevel and 0 or nextTimer(level,t)    endend--獲取信息local function getNameInfo(fullname)    if (not strfind(fullname, "-")) then fullname = fullname.."-"..GetRealmName() end    if (not TinyChatLevelDB[fullname]) then return end    return TinyChatLevelDB[fullname].lend--檢查信息local function checkNameInfo(fullname)    local t, realm = time(), GetRealmName()    if (not strfind(fullname, "-")) then fullname = fullname.."-"..realm end    if (not TinyChatLevelDB[fullname]) then return end    if (TinyChatLevelDB[fullname].t==0 or TinyChatLevelDB[fullname].t > t or realm ~= select(2, strsplit("-", fullname))) then        return true    endend--處理UNITlocal function unitEvent(unit)    if (UnitIsPlayer(unit)) then        local name, realm = UnitName(unit)        if (not realm) then realm = GetRealmName() end        nameFactory(name.."-"..realm, UnitLevel(unit), select(2,UnitClass(unit)), true)    endend--事件監聽local frame = CreateFrame("Frame", "ChatLevelFrame", UIParent)frame.OnEvent = function(self, event, ...)    local fullname, level, class    --好友    if (event == "FRIENDLIST_UPDATE") then        for i = 1, select(2, GetNumFriends()) do            fullname, level, class = GetFriendInfo(i)            nameFactory(fullname, level, class)        end    --公會    elseif (event == "GUILD_ROSTER_UPDATE") then        for i = 1, GetNumGuildMembers() do            fullname, _, _, level, _, _, _, _, _, _, class = GetGuildRosterInfo(i)            nameFactory(fullname, level, class)        end    --頻道    elseif (event == "CHAT_MSG_CHANNEL") then        fullname = select(2,...)        if (not checkNameInfo(fullname)) then            SetWhoToUI(1)            FriendsFrame:UnregisterEvent("WHO_LIST_UPDATE")            SendWho("n-"..fullname)        end    --SendWho回調    elseif (event == "WHO_LIST_UPDATE") then        for i = 1, GetNumWhoResults() do            fullname, _, level, _, _, _, class = GetWhoInfo(i)            nameFactory(fullname, level, class)        end    --隊伍/團隊/副本    elseif (event == "GROUP_ROSTER_UPDATE") then        if (IsInRaid()) then            for i = 1, GetNumGroupMembers() do                fullname, _, _, level, _, class = GetRaidRosterInfo(i)                nameFactory(fullname, level, class)            end        else            for i = 1, GetNumSubgroupMembers() do                unitEvent("party"..i)            end        end    --UNIT    elseif (event == "UNIT_TARGET") then unitEvent("target")    elseif (event == "UNIT_LEVEL") then unitEvent(...)    elseif (event == "UPDATE_MOUSEOVER_UNIT") then unitEvent("mouseover")    --是否清理數據    elseif (event == "VARIABLES_LOADED") then        if (flushElapsed > 0) then            local today = date("%Y%m%d")            if (not TinyChatLevelDB.lastFlushDate or (today - TinyChatLevelDB.lastFlushDate) > flushElapsed) then                TinyChatLevelDB = { lastFlushDate = today }            end        end        self:UnregisterEvent("VARIABLES_LOADED")        --self:RegisterEvent("GROUP_ROSTER_UPDATE") --暫不註冊:此事件刷得太猛        self:RegisterEvent("WHO_LIST_UPDATE")        if (locale == "zhTW") then --cwow據説有問題,沒環境測試,暫屏蔽吧            self:RegisterEvent("CHAT_MSG_CHANNEL")        end        self:RegisterEvent("GUILD_ROSTER_UPDATE")        self:RegisterEvent("FRIENDLIST_UPDATE")        self:RegisterEvent("UNIT_TARGET")        self:RegisterEvent("UPDATE_MOUSEOVER_UNIT")        self:RegisterEvent("UNIT_LEVEL")    endendframe:SetScript("OnEvent", frame.OnEvent)frame:RegisterEvent("VARIABLES_LOADED")hooksecurefunc("FriendsFrame_OnShow", function()    FriendsFrame:RegisterEvent("WHO_LIST_UPDATE")    SetWhoToUI(1)end)hooksecurefunc("FriendsFrame_OnHide", function()    FriendsFrame:UnregisterEvent("WHO_LIST_UPDATE")end)--HACK 某些情況下會造成戰場按鈕taintlocal _GetColoredName = GetColoredNamefunction GetColoredName(event, arg1, arg2, arg3, arg4, arg5, arg6, arg7, arg8, arg9, arg10, arg11, arg12)    local level = getNameInfo(arg2)    local name = _GetColoredName(event, arg1, arg2, arg3, arg4, arg5, arg6, arg7, arg8, arg9, arg10, arg11, arg12)    if (TinyChatDB and TinyChatDB.HideChatLevel) then return name end    if (level) then        if (strfind(name, "\124c")) then            return name:gsub("(\124cff%x%x%x%x%x%x)(.-)(\124r)", "%1"..level..":%2%3")        else            return level..":"..name        end    else        return name    endend