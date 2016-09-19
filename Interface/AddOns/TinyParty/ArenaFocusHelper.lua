------------------------------------- 競技場隊友被敵方選中目標高亮提示-- Author:M-----------------------------------local friends = { "party1", "party2", "party3", "palyer" }local enemies = { "arena1", "arena2", "arena3" }do    local parent    for i = 1, MAX_PARTY_MEMBERS do        parent = _G["PartyMemberFrame"..i]        parent.focusLayout = CreateFrame("Frame", nil, parent)        parent.focusLayout:SetSize(128, 64)        parent.focusLayout:SetPoint("TOPLEFT", 0, -2)        parent.focusLayout.Focus = parent.focusLayout:CreateTexture(nil, "ARTWORK")        parent.focusLayout.Focus:SetTexture("Interface\\Cursor\\Crosshairs")        parent.focusLayout.Focus:SetVertexColor(1, 0, 0)        parent.focusLayout.Focus:SetSize(44, 44)        parent.focusLayout.Focus:SetPoint("TOPLEFT", 3, -2)        parent.focusLayout:SetFrameLevel(88)        parent.focusLayout:SetAlpha(0)    end    parent = _G["PlayerFrame"]    parent.focusLayout = CreateFrame("Frame", nil, parent)    parent.focusLayout:SetSize(128, 64)    parent.focusLayout:SetPoint("TOPLEFT", 10, -12)    parent.focusLayout.Focus = parent.focusLayout:CreateTexture(nil, "ARTWORK")    parent.focusLayout.Focus:SetTexture("Interface\\Cursor\\Crosshairs")    parent.focusLayout.Focus:SetVertexColor(1, 0, 0)    parent.focusLayout.Focus:SetSize(68, 68)    parent.focusLayout.Focus:SetPoint("CENTER")    parent.focusLayout:SetFrameLevel(88)    parent.focusLayout:SetAlpha(0)end--隱藏標記local function hide()    _G["PlayerFrame"].focusLayout:SetAlpha(0)    for i = 1, MAX_PARTY_MEMBERS do        _G["PartyMemberFrame"..i].focusLayout:SetAlpha(0)    endend--清空數據local function clear(self)    for k, v in pairs(self.units) do        self.units[k] = nil    end    hide()end--重置數據local function restore(self)    local name, realm, units    local server = GetRealmName()    for _, unit in ipairs(friends) do        name, realm = UnitName(unit)        if (not realm) then realm = server end        if (name) then            units = self.units[name.."-"..realm]            if (units) then                units.count = 0            else                self.units[name.."-"..realm] = {["count"]=0, ["unit"]=unit}            end        end    endend--分析並顯示local function analysis(self)    local i, unit = 0    for k, v in pairs(self.units) do        if (v.count > i) then            i = v.count            unit = v.unit        end    end    hide()    if (unit == "player") then        _G["PlayerFrame"].focusLayout:SetAlpha(1)    elseif (unit) then        i = unit:gsub("%D+", "")        if (i) then _G["PartyMemberFrame"..i].focusLayout:SetAlpha(1) end    endend--更新頻率local function ArenaFocus_OnUpdate(self, elapsed)    local name, realm, units    self.timer = (self.timer or 0) + elapsed	if self.timer >= 0.3 then        restore(self)        for _, unit in ipairs(enemies) do            name, realm = UnitName(unit.."target")            if (name and realm and not UnitIsDead(unit)) then                units = self.units[name.."-"..realm]                if (units) then                    units.count = units.count + 1                end            end        end        analysis(self)        self.timer = 0    endend--初始化local function ArenaFocus_Initialization(self)    local _, instanceType = IsInInstance()    if not self.units then self.units = {} end    if (instanceType == "arena") then        restore(self)        self:Show()    else        clear(self)        self:Hide()    endend--創建框架local frame = CreateFrame("Frame", "ArenaFocusFrame", UIParent)frame:Hide()frame:RegisterEvent("PLAYER_ENTERING_WORLD")frame:SetScript("OnUpdate", ArenaFocus_OnUpdate)frame:SetScript("OnEvent", function(self, event, ...)    if (event == "PLAYER_ENTERING_WORLD") then        ArenaFocus_Initialization(self)    endend)