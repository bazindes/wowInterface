--------------------------------------- 系統施法條都顯示施法時間-------------------------------------local function CreateFontString(self)    self.CooldownText = self:CreateFontString(nil)    self.CooldownText:SetFont(SystemFont_Outline_Small:GetFont(), 8, "OUTLINE")    self.CooldownText:SetWidth(60)    self.CooldownText:SetJustifyH("RIGHT")    self.CooldownText:SetPoint("RIGHT", self, "RIGHT", -2, 1)    local fontFile, fontSize, fontFlags = self.Text:GetFont()     self.Text:SetFont(fontFile, fontSize-2, fontFlags)endlocal function ShowCastingTimer(self, elapsed)    if (not self.CooldownText) then        CreateFontString(self)        self.timer = 0        if (self:GetName() == "CastingBarFrame") then            self.Border:SetTexture("Interface\\CastingBar\\UI-CastingBar-Border-Small")            self.Flash:SetTexture("Interface\\CastingBar\\UI-CastingBar-Flash-Small")            self.Border:SetPoint("TOP", 0, 26)            self.Text:SetPoint("TOP", 0, 3)            self.Icon:Show()            self.Icon:SetSize(20,20)        end    end    self.timer = self.timer + elapsed    if (self.timer > 0.1) then        self.timer = 0        if self.casting then            self.CooldownText:SetText(format("%.1f/%.1f", max(self.value, 0), self.maxValue))        elseif self.channeling then            self.CooldownText:SetText(format("%.1f", max(self.value, 0)))        else            self.CooldownText:SetText("")        end    endendhooksecurefunc("CastingBarFrame_OnUpdate", ShowCastingTimer)hooksecurefunc("CastingBarFrame_OnEvent", function(self, event, ...)    if (not self.hasRegisterCastingTimer) then        self.hasRegisterCastingTimer = true        local func = self:GetScript("OnUpdate")        if (func ~= CastingBarFrame_OnUpdate) then            self:SetScript("OnUpdate", CastingBarFrame_OnUpdate)        end    endend)if (CastingBarFrame) then    CastingBarFrame:HookScript("OnUpdate", ShowCastingTimer)endhooksecurefunc("MirrorTimerFrame_OnUpdate", function(self, elapsed)    if (self.paused) then return end    if (not self.CooldownText) then        self.CooldownText = self:CreateFontString(nil)        self.CooldownText:SetFont(SystemFont_Outline_Small:GetFont(), 8, "OUTLINE")        self.CooldownText:SetWidth(100)        self.CooldownText:SetJustifyH("RIGHT")        self.CooldownText:SetPoint("RIGHT", self, "RIGHT", -10, 6)        self.itimer = 0        _G[self:GetName().."Border"]:SetTexture("Interface\\CastingBar\\UI-CastingBar-Border-Small")        _G[self:GetName().."StatusBar"]:SetHeight(14)        _G[self:GetName().."StatusBar"]:SetPoint("TOP", 0, -1)    end    self.itimer = self.itimer + elapsed    if (self.itimer > 0.5) then        self.itimer = 0        self.CooldownText:SetText(floor(self.value))    endend)