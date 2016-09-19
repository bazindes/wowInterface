RicoMiniMap = AceLibrary("AceAddon-2.0"):new("AceEvent-2.0", "AceConsole-2.0", "AceDB-2.0")
RicoMiniMap:RegisterDB("RicoMiniMapDB")
local dewdrop = AceLibrary("Dewdrop-2.0")
local RicoMiniMapHidden = false
local strataNames = {"BACKGROUND", "LOW", "MEDIUM", "HIGH", "DIALOG", "FULLSCREEN", "FULLSCREEN_DIALOG", "TOOLTIP"}
local L = AceLibrary("AceLocale-2.2"):new("RicoMM")
local PingingUnit;
local addonName = ...

local LDB = LibStub:GetLibrary("LibDataBroker-1.1")
RicoMiniMap_LDB = LDB:NewDataObject( "RicoMiniMapLDB", {type = "data source", text = "RicoMM", label = "RicoMiniMapLDB", icon = "Interface\\Addons\\RicoMiniMap\\icon.tga"} )

local RicoMiniMap_LDB_Frame = CreateFrame("Frame")

RicoMiniMap_OptionTable = {
	type    = "group",
	handler = RicoMiniMap,
	args = {
		RicoMiniMap_DragLock = {
			type = "toggle",
			order = 1,
			name = L["Locked"],
			desc = L["Prevent dragging the map or buttons"],
			get  = function() return RicoMiniMap:IsLocked() end,
			set  = function() RicoMiniMap:ToggleLocked() end,
		},
		RicoMiniMap_CoordPos={
			type ="group",
			name =L["Coordinates Position"], 
			desc =L["Choose the location of the coordinates"],
			args ={
				CoordPos3 = {
					type = "toggle", 
					name = L["Inside Top"], 
					desc = L["Inside Top"],
					get  = function() return(RicoMiniMap:GetCoordinatesPosition() == 3) end,
					set  = function() RicoMiniMap:SetCoordinatesPosition(3) RicoMiniMap:UpdateCoordinatesPosition() end
				},
				CoordPos4 = {
					type = "toggle", 
					name = L["Outside Top"], 
					desc = L["Outside Top"],
					get  = function() return(RicoMiniMap:GetCoordinatesPosition() == 4) end,
					set  = function() RicoMiniMap:SetCoordinatesPosition(4) RicoMiniMap:UpdateCoordinatesPosition() end
				},
				CoordPos1 = {
					type = "toggle", 
					name = L["Inside Bottom"], 
					desc = L["Inside Bottom"],
					get  = function() return(RicoMiniMap:GetCoordinatesPosition() == 1) end,
					set  = function() RicoMiniMap:SetCoordinatesPosition(1) RicoMiniMap:UpdateCoordinatesPosition() end
				},
				CoordPos2 = {
					type = "toggle", 
					name = L["Outside Bottom"], 
					desc = L["Outside Bottom"],
					get  = function() return(RicoMiniMap:GetCoordinatesPosition() == 2) end,
					set  = function() RicoMiniMap:SetCoordinatesPosition(2) RicoMiniMap:UpdateCoordinatesPosition() end
				},
			},
		},
		RicoMiniMap_Positions = {
			type  = "group",
			order = 2,
			name  = "Position Storage",
			desc  = "Save or Restore positions.",
			args  = {
				Save = {
					type = "execute",
					order = 1,
					name = "Save",
					desc = "Save the positions of the minimap frames.",
					func = "SavePositions",
				},
				Restore = {
					type = "execute",
					order = 2,
					name = "Restore",
					desc = "Restore to saved positions of the minimap frames.",
					func = "RestorePositions",
				},
			},
		},
		RicoMiniMap_Locations = {
			type = "group",
			order = 2.5,
			name = "Location Presets",
			desc = "Move the minimap to preset locations.",
			args = {
				BottomLeft = {
					type = "execute",
					order = 1,
					name = "Bottom Left",
					desc = "Move the minimap to the bottom left corner of the screen.",
					func = "SetMapLocationBL",
				},
				BottomCenter = {
					type = "execute",
					order = 2,
					name = "Bottom Center",
					desc = "Move the minimap to the bottom center of the screen.",
					func = "SetMapLocationBC",
				},
				BottomRight = {
					type = "execute",
					order = 3,
					name = "Bottom Right",
					desc = "Move the minimap to the bottom right corner of the screen.",
					func = "SetMapLocationBR",
				},
				Left = {
					type = "execute",
					order = 4,
					name = "Left",
					desc = "Move the minimap to the left center of the screen.",
					func = "SetMapLocationLC",
				},
				Right = {
					type = "execute",
					order = 5,
					name = "Right",
					desc = "Move the minimap to the right center corner of the screen.",
					func = "SetMapLocationRC",
				},
				TopLeft = {
					type = "execute",
					order = 6,
					name = "Top Left",
					desc = "Move the minimap to the top left corner of the screen.",
					func = "SetMapLocationTL",
				},
				TopCenter = {
					type = "execute",
					order = 7,
					name = "Top Center",
					desc = "Move the minimap to the top center of the screen.",
					func = "SetMapLocationTC",
				},
				TopRight = {
					type = "execute",
					order = 8,
					name = "Top Right",
					desc = "Move the minimap to the top right corner of the screen.",
					func = "SetMapLocationTR",
				}
			},
		},
		RicoMiniMap_Toggles = {
			type = "group",
			order = 3,
			name = "Toggles",
			desc = "Toggles",
			handler = RicoMiniMap,
			args = {
				RicoMiniMap_ZoomButtons = {
					type = "toggle",
					name = L["Show Zoom Buttons"],
					desc = L["Show the zoom in and zoom out buttons"],
					get  = function() return RicoMiniMap:IsShowingZoomButtons() end,
					set  = function() RicoMiniMap:ToggleShowingZoomButtons() end,
				},
				RicoMiniMap_Coordinates = {
					type = "toggle",
					name = L["Show Coordinates"],
					desc = L["Show your location coordiates"],
					get  = function() return RicoMiniMap:IsShowingCoordinates() end,
					set  = function() RicoMiniMap:SetShowingCoordinates("toggle") end,
				},
				RicoMiniMap_CoordinateTenths = {
					type = "toggle",
					name = L["Show Coordinate Tenths"],
					desc = L["Show your location with tenths"],
					get  = function() return RicoMiniMap:IsShowingCoordinateTenths() end,
					set  = function() RicoMiniMap:ToggleShowingCoordinateTenths() end,
				},
				RicoMiniMap_MapButton = {
					type = "toggle",
					name = L["Show Map Button"],
					desc = L["Show the world map button"],
					get  = function() return RicoMiniMap:IsShowingMapButton() end,
					set  = function() RicoMiniMap:SetShowingMapButton("toggle") end,
				},
				RicoMiniMap_TimeButton = {
					type = "toggle",
					name = L["Show Time Button"],
					desc = L["Show the time button"],
					get  = function() return RicoMiniMap:IsShowingTimeButton() end,
					set  = function() RicoMiniMap:SetShowingTimeButton("toggle") end,
				},
				RicoMiniMap_ClockButton = {
					type = "toggle",
					name = L["ShowClock"],
					desc = L["ShowClock"],
					get  = function() return RicoMiniMap:IsShowingClock() end,
					set  = function() RicoMiniMap:SetShowingClock("toggle") end,
				},
				RicoMiniMap_TrackingButton = {
					type = "toggle",
					name = L["Show Tracking Button"],
					desc = L["Show the tracking button"],
					get  = function() return RicoMiniMap:IsShowingTrackingButton() end,
					set  = function() RicoMiniMap:ToggleShowingTrackingButton() end,
				},
				RicoMiniMap_MailButton = {
					type = "toggle",
					name = L["Show Mail Button"],
					desc = L["Show the mail button"],
					get  = function() return RicoMiniMap:IsShowingMailButton() end,
					set  = function() RicoMiniMap:SetShowingMailButton("toggle") end,
				},
				RicoMiniMap_ZoneLabel = {
					type = "toggle",
					name = L["Show Zone Text"],
					desc = L["Show the default zone text"],
					get  = function() return RicoMiniMap:IsShowingZoneText() end,
					set  = function() RicoMiniMap:ToggleShowingZoneText() end,
				},
				RicoMiniMap_Border = {
					type = "toggle",
					name = L["Show Minimap Border"],
					desc = L["Toggle the minimap border"],
					get  = function() return RicoMiniMap:IsShowingBorder() end,
					set  = function() RicoMiniMap:ToggleShowingBorder() end,
				},
				RicoMiniMap_RCMenu = {
					type = "toggle",
					name = L["Show Menu"],
					desc = L["Toggle showing the menu on right-click.  '/rmm menu' to re-enable"],
					get  = function() return RicoMiniMap:IsShowingMenu() end,
					set  = function() RicoMiniMap:ToggleShowingMenu() end,
				},
				RicoMiniMap_WatchFrameToggle = {
					type = "toggle", 
					name = "Show Quest Watcher", 
					desc = "Turn off the Quest Watcher frame.",
					get  = function() return RicoMiniMap:IsShowingQuestWatcher() end,
					set  = function() RicoMiniMap:SetShowingQuestWatcher("toggle") end
				},
				RicoMiniMap_HoverToggle = {
					type = "toggle", 
					name = "Turn Opaque on Mouseover", 
					desc = "Set the minimap to 100% opaque on mouseover.",
					get  = function() return RicoMiniMap:IsHoverToggleOn() end,
					set  = function() RicoMiniMap:SetHoverToggle("toggle") end
				},
			},
		},
		RicoMiniMap_ZoneTextLocation = {
			type = "range",
			name = L["Zone Text Location"],
			desc = L["Set the location of the zone text"],
			max = 0,
			min = -30,
			step = 1,
			get = "GetZoneTextLocation",
			set = "SetZoneTextLocation",
		},
		
		RicoMiniMap_Shape={
			type ="group",
			name =L["Shape"], 
			desc =L["Choose the shape of the minimap"],
			args ={
				Shape1 = {
					type = "toggle", 
					name = L["Bottom Left"], 
					desc = L["Bottom Left corner is rounded"],
					get  = function() return(RicoMiniMap:GetShape() == 1) end,
					set  = function() RicoMiniMap:SetShape(1) RicoMiniMap:UpdateShape() end
				},
				Shape2 = {
					type = "toggle", 
					name = L["Square"], 
					desc = L["All four corners square"],
					get  = function() return(RicoMiniMap:GetShape() == 2) end,
					set  = function() RicoMiniMap:SetShape(2) RicoMiniMap:UpdateShape() end
				},
				Shape4 = {
					type = "toggle", 
					name = "Square Gold", 
					desc = "Square with gold frame",
					get  = function() return(RicoMiniMap:GetShape() == 4) end,
					set  = function() RicoMiniMap:SetShape(4) RicoMiniMap:UpdateShape() end
				},
				Shape3 = {
					type = "toggle", 
					name = L["Round"], 
					desc = L["All four corners round"],
					get  = function() return(RicoMiniMap:GetShape() == 3) end,
					set  = function() RicoMiniMap:SetShape(3) RicoMiniMap:UpdateShape() end
				},
				Shape5 = {
					type = "toggle", 
					name = "Round Gold", 
					desc = "Round gold border",
					get  = function() return(RicoMiniMap:GetShape() == 5) end,
					set  = function() RicoMiniMap:SetShape(5) RicoMiniMap:UpdateShape() end
				},
			},
		},
		RicoMiniMap_Strata = {
			type = "range",
			name = L["Strata"],
			desc = L["Change the minimap strata"],
			max = 8, 
			min = 1,
			step = 1,
			get = "GetMapStrata",
			set = "SetMapStrata",
		},
		RicoMiniMap_Scale = {
			type = "range",
			name = L["Scale"],
			desc = L["Scale the minimap from 50% to 250% in 1% increments"],
			max = 2.5, 
			min = 0.5,
			step = 0.01,
			isPercent = true,
			get = "GetMapScale",
			set = "SetMapScale",
		},
		RicoMiniMap_Alpha = {
			type = "range",
			name = L["Transparency"],
			desc = L["Set the transparency of the MiniMap"],
			max = 1,
			min = 0.1,
			step = 0.05,
			get = "GetAlpha",
			set = "SetAlpha",
		},
		RicoMiniMap_PingNotificationType={
			type ="group",
			name =L["PingNotificationType"], 
			desc =L["Choose the ping notification type"],
			args ={
				Shape1 = {
					type = "toggle", 
					order= 1, 
					name = L["None"], 
					desc = L["Don't display who pinged."],
					get  = function() return(RicoMiniMap:GetPingNotificationType() == 0) end,
					set  = function() RicoMiniMap:SetPingNotificationType(0) end
				},
				Shape2 = {
					type = "toggle", 
					order= 2, 
					name = L["Default Chat"], 
					desc = L["Identify who pinged in default chat."],
					get  = function() return(RicoMiniMap:GetPingNotificationType() == 1) end,
					set  = function() RicoMiniMap:SetPingNotificationType(1) end
				},
			},
		},
		RicoMiniMap_WatchFrameScale = {
			type = "range",
			name = L["WatchFrameScale"],
			desc = L["Scale the WatchFrame from 50% to 150% in 1% increments"],
			max = 1.5, 
			min = 0.5,
			step = 0.01,
			isPercent = true,
			get = "GetWatchFrameScale",
			set = "SetWatchFrameScale",
		},
		RicoMiniMap_WatchFrameHeight = {
			type = "range",
			name = L["WatchFrameHeight"],
			desc = L["Set the WatchFrame height to show more quests"],
			max = 1000, 
			min = 200,
			step = 5,
			isPercent = false,
			get = "GetWatchFrameHeight",
			set = "SetWatchFrameHeight",
		},
	},
}

RicoMiniMap:RegisterDefaults('profile', {
  	ShowCoordinates = true,
  	ShowTenths = true,
  	ShowZoneText = false,
  	ZoneTextOffset = 30,
  	ShowZoomButtons = false,
  	ShowMapButton = false,
  	ShowTrackingButton = true,
  	ShowMailButton = true,
  	ShowTime = false,
  	Scale = 1.0,
  	Strata = 1,
  	Shape = 2,
  	CoordinatesPosition = 1,
  	Alpha = 1,
  	PingNotificationType = 1,
  	WatchFrameScale = 1,
  	WatchFrameHeight = 300,
  	ShowClock = false,
  	ShowQuestWatcher = true,
  	HoverOpaque = false
	}
)

local DoNothing = function() end

local function GetPercent(value)
	value = tonumber(value) or 1
	return value <= 0.1 and 0.1 or value >= 2 and 2 or value
end

function RicoMiniMap:OnInitialize()
	self:RegisterEvent("MINIMAP_ZONE_CHANGED")
	self:RegisterEvent("DISPLAY_SIZE_CHANGED")
	self:RegisterEvent("MINIMAP_PING")

	self.slashOptions = {
		name = "RicoMiniMap",
		desc = L["A customizable MiniMap"],
		type = "group",
		args = {
			[L["config"]] = {
				name = L["config"],
				type = "execute",
				desc = L["Open the config menu."],
				func = function() dewdrop:Open(Minimap) end,
			},
			[L["reset"]] = {
				name = L["reset"],
				type = "execute",
				desc = L["Reset the minimap's position."],
				func = "ResetPositions",
			},				
			[L["menu"]] = {
				name = L["menu"],
				type = "execute",
				desc = L["Enable the menu on right-click."],
				func = function() self.db.profile.ShowMenu = true RicoMiniMap:UpdateMinimapMenu() end,
			},				
			[L["hide"]] = {
				name = L["hide"],
				type = "execute",
				desc = L["Hide the entire minimap."],
				func = function() RicoMiniMapHidden = true RicoMiniMap:UpdateShape() end,
			},				
			[L["show"]] = {
				name = L["show"],
				type = "execute",
				desc = L["Show the minimap."],
				func = function() RicoMiniMapHidden = false RicoMiniMap:UpdateShape() end,
			},				
			["savepos"] = {
				name = "save",
				type = "execute",
				desc = "Save the positions of the minimap frames.",
				func = "SavePositions",
			},				
			["restore"] = {
				name = "restore",
				type = "execute",
				desc = "Restore saved positions of the minimap frames.",
				func = "RestorePositions",
			},				
		}
	}

	if self.db.char.HasMoved == nil then
		RicoMiniMap:ResetPositions()
		self.db.char.HasMoved = true
	end
	
	MinimapCluster:SetScale(RicoMiniMap:GetMapScale())
	RicoMiniMap:SetMapStrata(RicoMiniMap:GetMapStrata())
	MinimapCluster:SetMovable(true)
	MinimapCluster:SetUserPlaced(true)
	MinimapCluster:SetPoint("BOTTOMLEFT", UIParent, "BOTTOMLEFT", self.db.profile.minimapX, self.db.profile.minimapY)
	Minimap:RegisterForDrag("LeftButton")
	Minimap:SetScript("OnDragStart", function() self:RMMFrameDrag(MinimapCluster,true) end)
	Minimap:SetScript("OnDragStop", function() self:RMMFrameDrag(MinimapCluster,false) end)
	MinimapBorder:SetParent(Minimap)

	MinimapZoneTextButton:ClearAllPoints()
	MinimapZoneTextButton:SetPoint("TOPRIGHT", -20, self.db.profile.ZoneTextLocation)
	MinimapZoneTextButton:SetFrameStrata("LOW")

	MinimapBorderTop:Hide()
	
	if ObjectiveTrackerFrame.Parent == MinimapCluster then
		ObjectiveTrackerFrame:ClearAllPoints()
		ObjectiveTrackerFrame:SetPoint("BOTTOMLEFT", self.db.profile.questX, self.db.profile.questY)
		ObjectiveTrackerFrame:SetScale(RicoMiniMap:GetWatchFrameScale())
		ObjectiveTrackerFrame:SetHeight(RicoMiniMap:GetWatchFrameHeight())
		ObjectiveTrackerFrame:SetClampedToScreen(true)
		ObjectiveTrackerFrame:SetMovable(true)
		ObjectiveTrackerFrame:SetUserPlaced(true)
	end
	
	if ObjectiveTrackerFrame.Parent == MinimapCluster then
		local OTMover = CreateFrame("FRAME", "ObjectiveTrackerMover", ObjectiveTrackerFrame)  
		OTMover:SetHeight(24)
		OTMover:EnableMouse(true)
		OTMover:RegisterForDrag("LeftButton")
		OTMover:SetPoint("TOPLEFT", ObjectiveTrackerFrame, -11, -1)
		OTMover:SetPoint("TOPRIGHT", ObjectiveTrackerFrame)
		OTMover:SetHitRectInsets(-5, -5, -5, -5)
		OTMover:SetScript("OnDragStart", function() self:RMMFrameDrag(ObjectiveTrackerFrame,true) end)
		OTMover:SetScript("OnDragStop", function() self:RMMFrameDrag(ObjectiveTrackerFrame,false) end)
	end

	self.OnMenuRequest = RicoMiniMap_OptionTable
	self.overrideMenu = true
	self:RegisterChatCommand({"/RicoMiniMap", "/rmm"}, self.slashOptions)

	RicoMiniMap:UpdateZoomButtons()
	RicoMiniMap:UpdateShape()
	RicoMiniMap:UpdateCoordinatesPosition()
	RicoMiniMap:UpdateMinimapMenu()
	RicoMiniMap:SetShowingClock()
	RicoMiniMap:SetShowingCoordinates()
	RicoMiniMap:SetShowingMapButton()
	RicoMiniMap:SetShowingTimeButton()
	RicoMiniMap:SetShowingQuestWatcher()
	RicoMiniMap:SetShowingMailButton()
	RicoMiniMap:SetHoverToggle()

	MiniMapMailFrame:ClearAllPoints()
	MiniMapMailFrame:SetPoint('TOPLEFT', Minimap, -2, 25)
	MiniMapMailFrame:SetHeight(10)
	MiniMapMailFrame:SetFrameStrata("LOW")
	
	MiniMapTracking:ClearAllPoints()
	MiniMapTracking:SetPoint('BOTTOM', Minimap, -80, 140)
	MiniMapTracking:SetHeight(10)
	MiniMapTracking:SetFrameStrata("LOW")

	MiniMapVoiceChatFrame:ClearAllPoints()
  MiniMapVoiceChatFrame:Hide()

	GameTimeFrame:ClearAllPoints()
	GameTimeFrame:SetPoint('LEFT', Minimap, 136, 60)
	GameTimeFrame:SetFrameStrata("LOW")
	
	if RicoMiniMap:IsShowingZoneText() then
		MinimapZoneTextButton:Show()
	else
		MinimapZoneTextButton:Hide()
	end

	RicoMiniMap:UpdateAlpha()

	if not RicoMiniMap:IsLocked() then
		RicoMiniMap:ToggleLocked()
	end

end

function RicoMiniMap_OnLoad()
end


function RicoMiniMap_OnClick(frame, button)
	if button == "RightButton" and RicoMiniMap:IsShowingMenu() then
		RicoMiniMap:UpdateMinimapMenu()
	else
		Minimap_OnClick(frame, button)
	end
end

function RicoMiniMap:OnEnable()
end

function RicoMiniMap:RMMFrameDrag(frameName, moving)
	if moving and RicoMiniMap:IsLocked() == false then
		frameName.isMoving = true
		frameName:StartMoving()
	elseif frameName.isMoving then
		frameName.isMoving = false
		frameName:StopMovingOrSizing()
	end
end

function RicoMiniMap:ResetPositions()
	if RicoMiniMap:IsLocked() then
		RicoMiniMap:ToggleLocked()
	end

	DEFAULT_CHAT_FRAME:AddMessage("RMM reset")
end

function RicoMiniMap:SetMapLocationBC()
	MinimapCluster:ClearAllPoints()
	MinimapCluster:SetPoint("BOTTOM", UIParent, "BOTTOM")
end

function RicoMiniMap:SetMapLocationBL()
	MinimapCluster:ClearAllPoints()
	MinimapCluster:SetPoint("BOTTOMLEFT", UIParent, "BOTTOMLEFT")
end

function RicoMiniMap:SetMapLocationBR()
	MinimapCluster:ClearAllPoints()
	MinimapCluster:SetPoint("BOTTOMRIGHT", UIParent, "BOTTOMRIGHT")
end

function RicoMiniMap:SetMapLocationTC()
	MinimapCluster:ClearAllPoints()
	MinimapCluster:SetPoint("TOP", UIParent, "TOP")
end

function RicoMiniMap:SetMapLocationTL()
	MinimapCluster:ClearAllPoints()
	MinimapCluster:SetPoint("TOPLEFT", UIParent, "TOPLEFT")
end

function RicoMiniMap:SetMapLocationTR()
	MinimapCluster:ClearAllPoints()
	MinimapCluster:SetPoint("TOPRIGHT", UIParent, "TOPRIGHT")
end

function RicoMiniMap:SetMapLocationLC()
	MinimapCluster:ClearAllPoints()
	MinimapCluster:SetPoint("LEFT", UIParent, "LEFT")
end

function RicoMiniMap:SetMapLocationRC()
	MinimapCluster:ClearAllPoints()
	MinimapCluster:SetPoint("RIGHT", UIParent, "RIGHT")
end

function RicoMiniMap:SavePositions()
	self.db.profile.minimapX = MinimapCluster:GetLeft();
	self.db.profile.minimapY = MinimapCluster:GetBottom();
	self.db.profile.questX = ObjectiveTrackerFrame:GetLeft();
	self.db.profile.questY = ObjectiveTrackerFrame:GetBottom();
	--self.db.profile.ticketX = TicketFrame:GetLeft();
	--self.db.profile.ticketY = TicketFrame:GetBottom();
	--self.db.profile.vehicleX = VehicleSeatIndicator:GetLeft();
	--self.db.profile.vehicleY = VehicleSeatIndicator:GetBottom();
	--self.db.profile.durabilityX = DurabilityFrame:GetLeft();
	--self.db.profile.durabilityY = DurabilityFrame:GetBottom();

	dewdrop:Close();
	DEFAULT_CHAT_FRAME:AddMessage("RMM positions saved.");
end

function RicoMiniMap:RestorePositions()
  if self.db.profile.minimapX == nil then
  	RicoMiniMap:ResetPositions();
		DEFAULT_CHAT_FRAME:AddMessage("RMM positions not found.")
  else
  	MinimapCluster:ClearAllPoints()
		MinimapCluster:SetPoint("BOTTOMLEFT", UIParent, "BOTTOMLEFT", self.db.profile.minimapX, self.db.profile.minimapY)
	
		if ObjectiveTrackerFrame.Parent == MinimapCluster then
			ObjectiveTrackerFrame:ClearAllPoints() 
			ObjectiveTrackerFrame:SetPoint("BOTTOMLEFT", UIParent, "BOTTOMLEFT", self.db.profile.questX, self.db.profile.questY)
		end
		--TicketFrame:ClearAllPoints() 
		--TicketFrame:SetPoint("BOTTOMLEFT", UIParent, "BOTTOMLEFT", self.db.profile.ticketX, self.db.profile.ticketY)
		--VehicleSeatIndicator:ClearAllPoints() 
		--VehicleSeatIndicator:SetPoint("BOTTOMLEFT", UIParent, "BOTTOMLEFT", self.db.profile.vehicleX, self.db.profile.vehicleY)
		--DurabilityFrame:ClearAllPoints() 
		--DurabilityFrame:SetPoint("BOTTOMLEFT", UIParent, "BOTTOMLEFT", self.db.profile.durabilityX, self.db.profile.durabilityY)

		DEFAULT_CHAT_FRAME:AddMessage("RMM positions restored.")
	end

	dewdrop:Close()
end

function RicoMiniMap_LDB.OnClick()
	if RicoMiniMap:IsShowingMenu() then
		dewdrop:Open(Minimap)
	end
end

function RicoMiniMap:IsLocked()
	if self.db.profile.Locked == nil then
		self.db.profile.Locked = false
	end
	return self.db.profile.Locked
end

function RicoMiniMap:ToggleLocked()
	if self.db.profile.Locked == true then
		self.db.profile.Locked = false
 	else
		self.db.profile.Locked = true
	end
	return self.db.profile.Locked
end

function RicoMiniMap:IsShowingCoordinates()
	if self.db.profile.ShowCoordinates == nil then
		self.db.profile.ShowCoordinates = true
	end
	return self.db.profile.ShowCoordinates
end

function RicoMiniMap:SetShowingCoordinates(state)
	if state == "toggle" then
		self.db.profile.ShowCoordinates = not self.db.profile.ShowCoordinates
	end
	
	if state == "default" then
		self.db.profile.ShowCoordinates = true
	end	
	
	return self.db.profile.ShowCoordinates
end

function RicoMiniMap:IsHoverToggleOn()
	if self.db.profile.HoverOpaque == nil then
		self.db.profile.HoverOpaque = true
	end
	return self.db.profile.HoverOpaque
end

function RicoMiniMap:SetHoverToggle(state)
	if state == "toggle" then
		self.db.profile.HoverOpaque = not self.db.profile.HoverOpaque
	end
	
	if state == "default" then
		self.db.profile.HoverOpaque = true
	end	
	
	return self.db.profile.HoverOpaque
end


function RicoMiniMap:IsShowingQuestWatcher()
	if self.db.profile.ShowQuestWatcher == nil then
		self.db.profile.ShowQuestWatcher = true
	end
	return self.db.profile.ShowQuestWatcher
end

function RicoMiniMap:SetShowingQuestWatcher(state)
	if state == "toggle" then
		self.db.profile.ShowQuestWatcher = not self.db.profile.ShowQuestWatcher
	end
	
	if state == "default" then
		self.db.profile.ShowQuestWatcher = true
	end	
	
	if RicoMiniMap:IsShowingQuestWatcher() then
		ObjectiveTrackerFrame:Show()
	else
		ObjectiveTrackerFrame:Hide()
	end
end

function RicoMiniMap:IsShowingCoordinateTenths()
	if self.db.profile.ShowTenths == nil then
		self.db.profile.ShowTenths = true
	end
	return self.db.profile.ShowTenths
end

function RicoMiniMap:ToggleShowingCoordinateTenths()
	self.db.profile.ShowTenths = not self.db.profile.ShowTenths
	return self.db.profile.ShowTenths
end

function RicoMiniMap:IsShowingZoomButtons()
	if self.db.profile.ShowZoomButtons == nil then
		self.db.profile.ShowZoomButtons = false
	end
	return self.db.profile.ShowZoomButtons
end

function RicoMiniMap:ToggleShowingZoomButtons()
	self.db.profile.ShowZoomButtons = not self.db.profile.ShowZoomButtons
	RicoMiniMap:UpdateZoomButtons()
	return self.db.profile.ShowZoomButtons
end

function RicoMiniMap:UpdateZoomButtons()
	if RicoMiniMap:IsShowingZoomButtons() then
		MinimapZoomIn:Show()
  	MinimapZoomOut:Show()	
	else
		MinimapZoomIn:Hide()
  	MinimapZoomOut:Hide()	
	end
end

function RicoMiniMap:IsShowingMapButton()
	if self.db.profile.ShowMapButton == nil then
		self.db.profile.ShowMapButton = false
	end
	return self.db.profile.ShowMapButton
end

function RicoMiniMap:SetShowingMapButton(state)
	if state == "toggle" then
		self.db.profile.ShowMapButton = not self.db.profile.ShowMapButton
	end
	
	if state == "default" then
		self.db.profile.ShowMapButton = false
	end 
	
	if RicoMiniMap:IsShowingMapButton() then
		MiniMapWorldMapButton:Show()
	else
		MiniMapWorldMapButton:Hide()
	end
	return self.db.profile.ShowMapButton
end

function RicoMiniMap:IsShowingTimeButton()
	if self.db.profile.ShowTimeButton == nil then
		self.db.profile.ShowTimeButton = false
	end
	return self.db.profile.ShowTimeButton
end

function RicoMiniMap:SetShowingTimeButton(state)
	if state == "toggle" then
		self.db.profile.ShowTimeButton = not self.db.profile.ShowTimeButton
	end
	
	if state == "default" then
		self.db.profile.ShowTimeButton = false
	end
	
	if self.db.profile.ShowTimeButton then
		GameTimeFrame:Show()
	else
		GameTimeFrame:Hide()
	end
	
	return self.db.profile.ShowTimeButton
end

function RicoMiniMap:IsShowingClock()
	if self.db.profile.ShowClock == nil then
		self.db.profile.ShowClock = false
	end
	return self.db.profile.ShowClock
end

function RicoMiniMap:SetShowingClock(state)
	if state == "toggle" then
		self.db.profile.ShowClock = not self.db.profile.ShowClock
	end
	
	if state == "default" then
		self.db.profile.ShowClock = false
	end
	
	if RicoMiniMap:IsShowingClock() then
		if TimeManagerClockButton then TimeManagerClockButton:Show() end
	else
		if TimeManagerClockButton then TimeManagerClockButton:Hide() end
	end
	return self.db.profile.ShowClock
end

function RicoMiniMap:IsShowingTrackingButton()
	if self.db.profile.ShowTrackingButton == nil then
		self.db.profile.ShowTrackingButton = true
	end
	return self.db.profile.ShowTrackingButton
end

function RicoMiniMap:ToggleShowingTrackingButton()
	self.db.profile.ShowTrackingButton = not self.db.profile.ShowTrackingButton
	if RicoMiniMap:IsShowingTrackingButton() then
		MiniMapTracking:Show()
	else
		MiniMapTracking:Hide()
	end
	return self.db.profile.ShowTrackingButton
end

function RicoMiniMap:IsShowingMailButton()
	if self.db.profile.ShowMailButton == nil then
		self.db.profile.ShowMailButton = false
	end
	return self.db.profile.ShowMailButton
end

function RicoMiniMap:SetShowingMailButton(state)
	if state == "toggle" then
		self.db.profile.ShowMailButton = not self.db.profile.ShowMailButton
	end
	
	if state == "default" then
		self.db.profile.ShowMailButton = true
	end
	
	if RicoMiniMap:IsShowingMailButton() then
		MiniMapMailFrame:Show()
	else
		MiniMapMailFrame:Hide()
	end
	return self.db.profile.ShowMailButton
end

function RicoMiniMap:IsShowingZoneText()
	if self.db.profile.ShowZoneText == nil then
		self.db.profile.ShowZoneText = false
	end
	return self.db.profile.ShowZoneText
end

function RicoMiniMap:ToggleShowingZoneText()
	self.db.profile.ShowZoneText = not self.db.profile.ShowZoneText
	if RicoMiniMap:IsShowingZoneText() then
		MinimapZoneTextButton:Show()
	else
		MinimapZoneTextButton:Hide()
	end
	return self.db.profile.ShowZoneText
end

function RicoMiniMap:GetMapScale()
	if self.db.profile.Scale == nil then
		self.db.profile.Scale = 1.25
	end
	return self.db.profile.Scale
end

function RicoMiniMap:SetMapScale(value)
	MinimapCluster:SetScale(value)
	self.db.profile.Scale = value
end

function RicoMiniMap:GetWatchFrameScale()
	if self.db.profile.WatchFrameScale == nil then
		self.db.profile.WatchFrameScale = 1
	end
	return self.db.profile.WatchFrameScale
end

function RicoMiniMap:SetWatchFrameScale(value)
	ObjectiveTrackerFrame:SetScale(value)
	self.db.profile.WatchFrameScale = value
end

function RicoMiniMap:GetWatchFrameHeight()
	if self.db.profile.WatchFrameHeight == nil then
		self.db.profile.WatchFrameHeight = 500
	end
	return self.db.profile.WatchFrameHeight
end

function RicoMiniMap:SetWatchFrameHeight(value)
	ObjectiveTrackerFrame:SetHeight(value)
	self.db.profile.WatchFrameHeight = value
end

function RicoMiniMap:GetMapStrata()
	if self.db.profile.Strata == nil then
		self.db.profile.Strata = 1
	end
	return self.db.profile.Strata
end

function RicoMiniMap:SetMapStrata(value)
	MinimapCluster:SetFrameStrata(strataNames[value])
	self.db.profile.Strata = value
end

function RicoMiniMap:GetAlpha()
	if self.db.profile.Alpha == nil then
		self.db.profile.Alpha = 1
	end
	return self.db.profile.Alpha
end

function RicoMiniMap:SetAlpha(value)
	self.db.profile.Alpha = value
	RicoMiniMap:UpdateAlpha()
end

function RicoMiniMap:UpdateAlpha()
	Minimap:SetAlpha(RicoMiniMap:GetAlpha())
end

function RicoMiniMap:GetZoneTextLocation()
	if self.db.profile.ZoneTextLocation == nil then
		self.db.profile.ZoneTextLocation = -20
	end
	return self.db.profile.ZoneTextLocation
end

function RicoMiniMap:SetZoneTextLocation(value)
	MinimapZoneTextButton:ClearAllPoints()
	MinimapZoneTextButton:SetPoint("TOPRIGHT", -20, value)
	self.db.profile.ZoneTextLocation = value
end

function RicoMiniMap:GetShape()
	if self.db.profile.Shape == nil then
		self.db.profile.Shape = 1
	end
	return self.db.profile.Shape
end

function RicoMiniMap:SetShape(value)
	self.db.profile.Shape = value
end

function RicoMiniMap:UpdateShape()
	if RicoMiniMapHidden then
		MinimapCluster:Hide()
	else
		MinimapCluster:Show()
		local value = self.db.profile.Shape
		
		if value == 1 then
			texture = "Interface\\AddOns\\RicoMiniMap\\Shapes\\BottomLeftRound"
			mask = "Interface\\AddOns\\RicoMiniMap\\Shapes\\BottomLeftRoundMask"
			MinimapBorder:SetTexCoord(0, 1, 0, 1)
			MinimapBorder:SetPoint('TOPLEFT', -3, 3)
			MinimapBorder:SetPoint('BOTTOMRIGHT', 3, -3)
		end
		
		if value == 2 then
			texture = "Interface\\AddOns\\RicoMiniMap\\Shapes\\SquareBlizzard"
			mask = "Interface\\AddOns\\RicoMiniMap\\Shapes\\SquareMask"
			MinimapBorder:SetTexCoord(0, 1, 0, 1)
			MinimapBorder:SetPoint('TOPLEFT', -3, 3)
			MinimapBorder:SetPoint('BOTTOMRIGHT', 3, -3)
		end

		if value == 3 then
			texture = "Interface\\AddOns\\RicoMiniMap\\Shapes\\RoundBlizzard"
			mask = "Interface\\AddOns\\RicoMiniMap\\Shapes\\RoundMask"
			MinimapBorder:SetTexCoord(0, 1, 0, 1)
			MinimapBorder:SetPoint('TOPLEFT', 0, 0)
			MinimapBorder:SetPoint('BOTTOMRIGHT', 0, 0)
		end
		
		if value == 4 then
			texture = "Interface\\AddOns\\RicoMiniMap\\Shapes\\SquareGold"
			mask = "Interface\\AddOns\\RicoMiniMap\\Shapes\\SquareMask"
			MinimapBorder:SetTexCoord(0, 1, 0, 1)
			MinimapBorder:SetPoint('TOPLEFT', -3, 3)
			MinimapBorder:SetPoint('BOTTOMRIGHT', 3, -3)
		end

		if value == 5 then
			texture = "Interface\\AddOns\\RicoMiniMap\\Shapes\\RoundGold"
			mask = "Interface\\AddOns\\RicoMiniMap\\Shapes\\RoundMask"
			MinimapBorder:SetTexCoord(0, 1, 0, 1)
			MinimapBorder:SetPoint('TOPLEFT', 0, 0)
			MinimapBorder:SetPoint('BOTTOMRIGHT', 0, 0)
		end
		
		if RicoMiniMap:IsShowingBorder() then
			MinimapBorder:Show()
			MinimapBorder:SetTexture(texture)
			MinimapBorder:SetDrawLayer("ARTWORK")
		else
			MinimapBorder:Hide()
		end
		Minimap:SetMaskTexture(mask)
		RicoMiniMap:UpdateCoordinatesPosition()
	end
end

function RicoMiniMap:GetCoordinatesPosition()
	if self.db.profile.CoordinatesPosition == nil then
		self.db.profile.CoordinatesPosition = 1
	end
	return self.db.profile.CoordinatesPosition
end

function RicoMiniMap:SetCoordinatesPosition(value)
	self.db.profile.CoordinatesPosition = value
end

function RicoMiniMap:UpdateCoordinatesPosition()
	local value = self.db.profile.CoordinatesPosition
	RicoMinimap_CoordinatesFrame:ClearAllPoints()
	if value == 1 then
		if self.db.profile.Shape == 1 then
			RicoMinimap_CoordinatesFrame:SetPoint("BOTTOM", "Minimap", "BOTTOM", 30, 0)
		else
			RicoMinimap_CoordinatesFrame:SetPoint("BOTTOM", "Minimap", "BOTTOM", 0, 0)
		end
		RicoMinimap_CoordinatesFrame:SetBackdropColor(0, 0, 0, 0)
		RicoMinimap_CoordinatesFrame:SetBackdropBorderColor(0, 0, 0, 0)
	end
	if value == 2 then
		if self.db.profile.Shape == 1 then
			RicoMinimap_CoordinatesFrame:SetPoint("TOP", "Minimap", "BOTTOM", 30, 0)
		else
			RicoMinimap_CoordinatesFrame:SetPoint("TOP", "Minimap", "BOTTOM", 0, 0)
		end
		RicoMinimap_CoordinatesFrame:SetBackdropColor(0, 0, 0, 1)
		RicoMinimap_CoordinatesFrame:SetBackdropBorderColor(0, 0, 0, 1)
	end
	if value == 3 then
		if self.db.profile.Shape == 1 then
			RicoMinimap_CoordinatesFrame:SetPoint("TOP", "Minimap", "TOP", 30, 0)
		else
			RicoMinimap_CoordinatesFrame:SetPoint("TOP", "Minimap", "TOP", 0, 0)
		end
		RicoMinimap_CoordinatesFrame:SetBackdropColor(0, 0, 0, 0)
		RicoMinimap_CoordinatesFrame:SetBackdropBorderColor(0, 0, 0, 0)
	end
	if value == 4 then
		if self.db.profile.Shape == 1 then
			RicoMinimap_CoordinatesFrame:SetPoint("BOTTOM", "Minimap", "TOP", 30, 0)
		else
			RicoMinimap_CoordinatesFrame:SetPoint("BOTTOM", "Minimap", "TOP", 0, 0)
		end
		RicoMinimap_CoordinatesFrame:SetBackdropColor(0, 0, 0, 1)
		RicoMinimap_CoordinatesFrame:SetBackdropBorderColor(0, 0, 0, 1)
	end
end

function RicoMiniMap:IsShowingBorder()
	if self.db.profile.ShowBorder == nil then
		self.db.profile.ShowBorder = true
	end
	return self.db.profile.ShowBorder
end

function RicoMiniMap:ToggleShowingBorder()
	self.db.profile.ShowBorder = not self.db.profile.ShowBorder
	RicoMiniMap:UpdateShape()
	return self.db.profile.ShowBorder
end

function RicoMiniMap:IsShowingMenu()
	if self.db.profile.ShowMenu == nil then
		self.db.profile.ShowMenu = true
	end
	return self.db.profile.ShowMenu
end

function RicoMiniMap:ToggleShowingMenu()
	self.db.profile.ShowMenu = not self.db.profile.ShowMenu
	RicoMiniMap:UpdateMinimapMenu()
	return self.db.profile.ShowMenu
end

function RicoMiniMap:UpdateMinimapMenu()
	if RicoMiniMap:IsShowingMenu() then
		dewdrop:Register(Minimap,
			'children', function()
				dewdrop:FeedAceOptionsTable(RicoMiniMap_OptionTable)
			end
		)
	else
		dewdrop:Unregister(Minimap)
	end
end

function RicoMiniMap:GetPingNotificationType()
	if self.db.profile.PingNotificationType == nil then
		self.db.profile.PingNotificationType = 1
	end
	return self.db.profile.PingNotificationType
end

function RicoMiniMap:SetPingNotificationType(value)
	self.db.profile.PingNotificationType = value
end

------------------
-- Coordinates text
function RicoMiniMap_updateLocText()
	RicoMiniMap:SetShowingClock()
	if RicoMiniMap:IsShowingCoordinates() then
		RicoMinimap_CoordinatesFrame:Show()
		local x, y = GetPlayerMapPosition('player')
		if x == 0 and y == 0 then 
			RicoMinimap_CoordinatesText:SetText('')
		else
			if RicoMiniMap:IsShowingCoordinateTenths() then
				RicoMinimap_CoordinatesText:SetText(string.format('%.1f, %.1f', x*100, y*100))
			else
				RicoMinimap_CoordinatesText:SetText(string.format('%.0f, %.0f', x*100, y*100))
			end
		end
		RicoMinimap_CoordinatesFrame:SetWidth(RicoMinimap_CoordinatesText:GetWidth() + 20)
		RicoMinimap_CoordinatesFrame:SetHeight(RicoMinimap_CoordinatesText:GetHeight() + 12)
	else
		RicoMinimap_CoordinatesFrame:Hide()
	end
end

-------------------------------
-- Zooming with the mouse wheel
Minimap:SetScript(
"OnMouseWheel", function(self, direction)
	local zoom, maxZoom = self:GetZoom() + direction, self:GetZoomLevels()
	self:SetZoom(zoom >= maxZoom and maxZoom or zoom <= 0 and 0 or zoom)
end)

Minimap:EnableMouseWheel(true)
Minimap:UnregisterEvent("MINIMAP_UPDATE_ZOOM")

-----------------------------------------------------
-- Mouseover sets minimap transparency to 100% opaque
Minimap:SetScript("OnUpdate", function(self, elapsed)
	local current = GetMouseFocus()
  while current ~= nil do
  	if current == Minimap then
  	  if RicoMiniMap:IsHoverToggleOn() then
    		Minimap:SetAlpha(1)
      	return
      end
    end             
    current = current:GetParent()
  end
          
  RicoMiniMap:UpdateAlpha()
end)


-----------------
-- Event handlers
function RicoMiniMap:MINIMAP_ZONE_CHANGED()
	RicoMiniMap:UpdateShape()
end

function RicoMiniMap:DISPLAY_SIZE_CHANGED()
	RicoMiniMap:UpdateShape()
end

function RicoMiniMap:MINIMAP_PING()
	local NotificationType = RicoMiniMap:GetPingNotificationType()
	if NotificationType > 0 then
		if UnitIsVisible(arg1) == 1 then
			print(UnitName(arg1) .. " pinged the mini-map.")
		end	
	end
end

-- Fubar and Cartographer compatibility
function GetMinimapShape()
  local myShape = RicoMiniMap:GetShape()
	local shape = "CORNER-BOTTOMLEFT"
	if myShape == 2 then shape = "SQUARE" end
	if myShape == 3 then shape = "ROUND" end
	if myShape == 4 then shape = "SQUARE" end
	return shape
end
