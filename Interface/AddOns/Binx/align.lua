--[重载命令]
SlashCmdList["RELOADUI"] = function() ReloadUI() end
SLASH_RELOADUI1 = "/aa"






--[网格界面校正]
SLASH_EA1 = "/align" 

local f

SlashCmdList["EA"] = function()
if f then
f:Hide()
f = nil
else
f = CreateFrame('Frame', nil, UIParent)
f:SetAllPoints(UIParent)
local w = GetScreenWidth() / 128
local h = GetScreenHeight() / 72
for i = 0, 128 do
local t = f:CreateTexture(nil, 'BACKGROUND')
if i == 64 then
t:SetTexture(1, 0, 0, 0.5)
else
t:SetTexture(0, 0, 0, 0.5)
end
t:SetPoint('TOPLEFT', f, 'TOPLEFT', i * w - 1, 0)
t:SetPoint('BOTTOMRIGHT', f, 'BOTTOMLEFT', i * w + 1, 0)
end
for i = 0, 72 do
local t = f:CreateTexture(nil, 'BACKGROUND')
if i == 36 then
t:SetTexture(1, 0, 0, 0.5)
else
t:SetTexture(0, 0, 0, 0.5)
end
t:SetPoint('TOPLEFT', f, 'TOPLEFT', 0, -i * h + 1)
t:SetPoint('BOTTOMRIGHT', f, 'TOPRIGHT', 0, -i * h - 1)
end
end
end
