--------------------------
-- SyDurGlow.lua
-- Author: Sayoc
-- Date: 10.01.23
--自动售卖灰色物品
--------------------------
local  q, vl
local _G = getfenv(0)
local SlotDurStrs = {}
local items = {
	"Head 1",
	"Neck",
	"Shoulder 2",
	"Shirt",
	"Chest 3",
	"Waist 4",
	"Legs 5",
	"Feet 6",
	"Wrist 7",
	"Hands 8",
	"Finger0",
	"Finger1",
	"Trinket0",
	"Trinket1",
	"Back",
	"MainHand 9",
	"SecondaryHand 10",
	"Tabard",
}

local function GetMoneyString(value)
	local copper = mod(value, 100)
	local gold = floor(value / 10000)
	local silver = mod(floor(value / 100), 100)

	if gold > 0 then
		return format(" "..GOLD_AMOUNT_TEXTURE.." "..SILVER_AMOUNT_TEXTURE.." "..COPPER_AMOUNT_TEXTURE, gold,0,0, silver,0,0, copper,0,0)
	elseif silver > 0 then
		return format(" "..SILVER_AMOUNT_TEXTURE.." "..COPPER_AMOUNT_TEXTURE, silver,0,0, copper,0,0)
	else
		return format(" "..COPPER_AMOUNT_TEXTURE, copper,0,0)
	end
end

-------------------------------- Durability show ---------------------------------

local tooltip = CreateFrame("GameTooltip")
tooltip:SetOwner(WorldFrame, "ANCHOR_NONE")

PaperDollFrame:CreateFontString("SyDurRepairCost", "ARTWORK", "NumberFontNormal")
SyDurRepairCost:SetPoint("BOTTOMLEFT", "PaperDollFrame", "BOTTOMLEFT", 8, 13)

local function GetDurStrings(name)
	if(not SlotDurStrs[name]) then
		local slot = _G["Character" .. name .. "Slot"]
		SlotDurStrs[name] = slot:CreateFontString(nil, "OVERLAY", "NumberFontNormal")
		SlotDurStrs[name]:SetPoint("CENTER", slot, "BOTTOM", 0, 8)
	end
	return SlotDurStrs[name]
end

local function UpdateDurability()
	local durcost = 0

	for id, vl in pairs(items) do
		local slot, index = string.split(" ", vl)
		if index then
			local has, _, cost = tooltip:SetInventoryItem("player", id);
			local value, max = GetInventoryItemDurability(id)
			local SlotDurStr = GetDurStrings(slot)
			if(has and value and max and max ~= 0) then
				local percent = value / max				
				SlotDurStr:SetText('')
				if(ceil(percent * 100) < 100)then
					SlotDurStr:SetTextColor(1 - percent, percent, 0)
					SlotDurStr:SetText(ceil(percent * 100) .. "%")
				end
				durcost = durcost + cost
			else
				 SlotDurStr:SetText("")
			end
		end
	end

	SyDurRepairCost:SetText(GetMoneyString(durcost))
end




----------------------------------- Event --------------------------------------

local f = CreateFrame("Frame")
f:Hide()
f:RegisterEvent("UNIT_INVENTORY_CHANGED")
f:RegisterEvent("UPDATE_INVENTORY_DURABILITY")
f:RegisterEvent("PLAYER_TARGET_CHANGED")

f:SetScript("OnEvent", function(self, event, ...)
	if event == "UPDATE_INVENTORY_DURABILITY" then
		UpdateDurability()
	elseif event == "UNIT_INVENTORY_CHANGED" then
		UpdateDurability()
		
		
	elseif event == "PLAYER_TARGET_CHANGED" then
		
	end	
end)


-- --------------------------
-- 拾取框增强Improved Loot Frame
-- By Cybeloras of Detheroc/Mal'Ganis
-- --------------------------

local LovelyLootLoaded = IsAddOnLoaded("LovelyLoot")
local ISMOP = select(4, GetBuildInfo()) >= 50000

local i, t = 1, "Interface\\LootFrame\\UI-LootPanel"
if not LovelyLootLoaded then
	while true do
		local r = select(i, LootFrame:GetRegions())
		if not r then break end
		if r.GetText and r:GetText() == ITEMS then
			r:ClearAllPoints()
			r:SetPoint("TOP", ISMOP and 12 or -12, ISMOP and -5 or -19.5)
		elseif not ISMOP and r.GetTexture and r:GetTexture() == t then
			r:Hide()
		end
		i = i + 1
	end

	if not ISMOP then
		local top = LootFrame:CreateTexture("LootFrameBackdropTop")
		top:SetTexture(t)
		top:SetTexCoord(0, 1, 0, 0.3046875)
		top:SetPoint("TOP")
		top:SetHeight(78)

		local bottom = LootFrame:CreateTexture("LootFrameBackdropBottom")
		bottom:SetTexture(t)
		bottom:SetTexCoord(0, 1, 0.9296875, 1)
		bottom:SetPoint("BOTTOM")
		bottom:SetHeight(18)

		local mid = LootFrame:CreateTexture("LootFrameBackdropMiddle")
		mid:SetTexture(t)
		mid:SetTexCoord(0, 1, 0.3046875, 0.9296875)
		mid:SetPoint("TOP", top, "BOTTOM")
		mid:SetPoint("BOTTOM", bottom, "TOP")
	end
end

local p, r, x, y = "TOP", "BOTTOM", 0, -4
local buttonHeight = LootButton1:GetHeight() + abs(y)
local baseHeight = LootFrame:GetHeight() - (buttonHeight * LOOTFRAME_NUMBUTTONS)
if ISMOP then
	baseHeight = baseHeight - 5
end
local old_LootFrame_Show = LootFrame_Show
function LootFrame_Show(self, ...)
	LootFrame:SetHeight(baseHeight + (GetNumLootItems() * buttonHeight))
	local num = GetNumLootItems()
	for i = 1, GetNumLootItems() do
		if i > LOOTFRAME_NUMBUTTONS then
			local button = _G["LootButton"..i]
			if not button then
				button = CreateFrame("Button", "LootButton"..i, LootFrame, "LootButtonTemplate", i)
			end
			LOOTFRAME_NUMBUTTONS = i
		end
		if i > 1 then
			local button = _G["LootButton"..i]
			button:ClearAllPoints()
			button:SetPoint(p, "LootButton"..(i-1), r, x, y)
		end
	end
	
	return old_LootFrame_Show(self, ...)
end

local framesRegistered = {}
local function populateframesRegistered(...)
	wipe(framesRegistered)
	for i = 1, select("#", ...) do
		framesRegistered[i] = select(i, ...)
	end
end

local old_LootButton_OnClick = LootButton_OnClick
function LootButton_OnClick(self, ...)
	populateframesRegistered(GetFramesRegisteredForEvent("ADDON_ACTION_BLOCKED"))
	
	for i, frame in pairs(framesRegistered) do
		frame:UnregisterEvent("ADDON_ACTION_BLOCKED") -- fuck the rice-a-roni! (Blizzard throws a false taint error when attemping to loot the coins from a mob when the coins are the only loot on the mob)
	end
	
	old_LootButton_OnClick(self, ...)
	
	for i, frame in pairs(framesRegistered) do
		frame:RegisterEvent("ADDON_ACTION_BLOCKED")
	end
end