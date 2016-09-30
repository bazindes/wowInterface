-- A simple quick chatbar,with low memory cost :)
-- Creat Date : July,20,2011
-- Email : Neavo7@gmail.com
-- Version : 0.1

-- Nevo_Chatbar主框体 --
local chatFrame = SELECTED_DOCK_FRAME
local editBox = chatFrame.editBox
COLORSCHEME_BORDER   = { 0.3,0.3,0.3,1 }

local chat = CreateFrame("Frame","chat",UIParent)
chat:SetWidth(20); -- 主框体宽度
chat:SetHeight(200); -- 主框体高度
chat:SetPoint("BOTTOMLEFT",UIParent,37,40); -- 锚点,想移动位置的改这里


-- "说(/s)" --
local ChannelSay = CreateFrame("Button", "ChannelSay", chat);
ChannelSay:SetWidth(23);  -- 按钮宽度
ChannelSay:SetHeight(23);  -- 按钮高度
ChannelSay:SetPoint("TOP",chat,"TOP",0,0);   -- 锚点
ChannelSay:RegisterForClicks("AnyUp");
ChannelSay:SetScript("OnClick", function() ChannelSay_OnClick() end)

ChannelSayText = ChannelSay:CreateFontString("ChannelSayText", "OVERLAY")
ChannelSayText:SetFont("fonts\\ARHei.ttf", 15, "OUTLINE") -- 字体设置
ChannelSayText:SetJustifyH("CENTER")
ChannelSayText:SetWidth(25)
ChannelSayText:SetHeight(25)
ChannelSayText:SetText("说") -- 显示的文字
ChannelSayText:SetPoint("CENTER", 0, 0)
ChannelSayText:SetTextColor(1,1,1) -- 颜色

function ChannelSay_OnClick()
      ChatFrame_OpenChat("/s ", chatFrame)
end

-- "喊(/y)" --
local ChannelYell = CreateFrame("Button", "ChannelYell", chat);
ChannelYell:SetWidth(23);
ChannelYell:SetHeight(23);
ChannelYell:SetPoint("topright",ChannelSay,"TOPright",30,0);
ChannelYell:RegisterForClicks("AnyUp");
ChannelYell:SetScript("OnClick", function() ChannelYell_OnClick() end)

ChannelYellText = ChannelYell:CreateFontString("ChannelYellText", "OVERLAY")
ChannelYellText:SetFont("fonts\\ARHei.ttf", 15, "OUTLINE")
ChannelYellText:SetJustifyH("CENTER")
ChannelYellText:SetWidth(25)
ChannelYellText:SetHeight(25)
ChannelYellText:SetText("喊")
ChannelYellText:SetPoint("CENTER", 0, 0)
ChannelYellText:SetTextColor(255/255, 64/255, 64/255)

function ChannelYell_OnClick()
      ChatFrame_OpenChat("/y ", chatFrame)
end


-- "队伍(/p)" --
local ChannelParty = CreateFrame("Button", "ChannelParty", chat);
ChannelParty:SetWidth(23);
ChannelParty:SetHeight(23);
ChannelParty:SetPoint("topright",ChannelSay,"TOPright",60,0);
ChannelParty:RegisterForClicks("AnyUp");
ChannelParty:SetScript("OnClick", function() ChannelParty_OnClick() end)

ChannelPartyText = ChannelParty:CreateFontString("ChannelPartyText", "OVERLAY")
ChannelPartyText:SetFont("fonts\\ARHei.ttf", 15, "OUTLINE")
ChannelPartyText:SetJustifyH("CENTER")
ChannelPartyText:SetWidth(25)
ChannelPartyText:SetHeight(25)
ChannelPartyText:SetText("队")
ChannelPartyText:SetPoint("CENTER", 0, 0)
ChannelPartyText:SetTextColor(170/255, 170/255, 255/255)

function ChannelParty_OnClick()
      ChatFrame_OpenChat("/p ", chatFrame)
end

-- "公会(/g)" --
local ChannelGuild = CreateFrame("Button", "ChannelGuild", chat);
ChannelGuild:SetWidth(23);
ChannelGuild:SetHeight(23);
ChannelGuild:SetPoint("topright",ChannelSay,"TOPright",90,0);
ChannelGuild:RegisterForClicks("AnyUp");
ChannelGuild:SetScript("OnClick", function() ChannelGuild_OnClick() end)

ChannelGuildText = ChannelGuild:CreateFontString("ChannelGuildText", "OVERLAY")
ChannelGuildText:SetFont("fonts\\ARHei.ttf", 15, "OUTLINE")
ChannelGuildText:SetJustifyH("CENTER")
ChannelGuildText:SetWidth(25)
ChannelGuildText:SetHeight(25)
ChannelGuildText:SetText("会")
ChannelGuildText:SetPoint("CENTER", 0, 0)
ChannelGuildText:SetTextColor(64/255, 255/255, 64/255)

function ChannelGuild_OnClick()
      ChatFrame_OpenChat("/g ", chatFrame)
end

-- "团队(/raid)" --
local ChannelRaid = CreateFrame("Button", "ChannelRaid", chat);
ChannelRaid:SetWidth(23);
ChannelRaid:SetHeight(23);
ChannelRaid:SetPoint("topright",ChannelSay,"TOPright",120,0);
ChannelRaid:RegisterForClicks("AnyUp");
ChannelRaid:SetScript("OnClick", function() ChannelRaid_OnClick() end)

ChannelRaidText = ChannelRaid:CreateFontString("ChannelRaidText", "OVERLAY")
ChannelRaidText:SetFont("fonts\\ARHei.ttf", 15, "OUTLINE")
ChannelRaidText:SetJustifyH("CENTER")
ChannelRaidText:SetWidth(25)
ChannelRaidText:SetHeight(25)
ChannelRaidText:SetText("团")
ChannelRaidText:SetPoint("CENTER", 0, 0)
ChannelRaidText:SetTextColor(255/255, 127/255, 0)

function ChannelRaid_OnClick()
      ChatFrame_OpenChat("/raid ", chatFrame)
end


-- "副本(/i)" --
local Channel_03 = CreateFrame("Button", "Channel_03", chat);
Channel_03:SetWidth(23);
Channel_03:SetHeight(23);
Channel_03:SetPoint("topright",ChannelSay,"TOPright",150,0);
Channel_03:RegisterForClicks("AnyUp");
Channel_03:SetScript("OnClick", function() Channel_03_OnClick() end)

Channel_03Text = Channel_03:CreateFontString("Channel_03Text", "OVERLAY")
Channel_03Text:SetFont("fonts\\ARHei.ttf", 15, "OUTLINE")
Channel_03Text:SetJustifyH("CENTER")
Channel_03Text:SetWidth(25)
Channel_03Text:SetHeight(25)
Channel_03Text:SetText("副")
Channel_03Text:SetPoint("CENTER", 0, 0)
Channel_03Text:SetTextColor(255/255, 127/255, 0)

function Channel_03_OnClick()
      ChatFrame_OpenChat("/bg ", chatFrame)
end

-- "综合频道(/1)" --
local Channel_01 = CreateFrame("Button", "Channel_01", chat);
Channel_01:SetWidth(23);
Channel_01:SetHeight(23);
Channel_01:SetPoint("topright",ChannelSay,"TOPright",180,0);
Channel_01:RegisterForClicks("AnyUp");
Channel_01:SetScript("OnClick", function() Channel_01_OnClick() end)

Channel_01Text = Channel_01:CreateFontString("Channel_01Text", "OVERLAY")
Channel_01Text:SetFont("fonts\\ARHei.ttf", 15, "OUTLINE")
Channel_01Text:SetJustifyH("CENTER")
Channel_01Text:SetWidth(25)
Channel_01Text:SetHeight(25)
Channel_01Text:SetText("综")
Channel_01Text:SetPoint("CENTER", 0, 0)
Channel_01Text:SetTextColor(210/255, 180/255, 140/255)

function Channel_01_OnClick()
      ChatFrame_OpenChat("/1 ", chatFrame)
end

-- "交易频道(/2)" --
local Channel_02 = CreateFrame("Button", "Channel_02", chat);
Channel_02:SetWidth(23);
Channel_02:SetHeight(23);
Channel_02:SetPoint("topright",ChannelSay,"TOPright",210,0);
Channel_02:RegisterForClicks("AnyUp");
Channel_02:SetScript("OnClick", function() Channel_02_OnClick() end)

Channel_02Text = Channel_02:CreateFontString("Channel_02Text", "OVERLAY")
Channel_02Text:SetFont("fonts\\ARHei.ttf", 15, "OUTLINE")
Channel_02Text:SetJustifyH("CENTER")
Channel_02Text:SetWidth(25)
Channel_02Text:SetHeight(25)
Channel_02Text:SetText("交")
Channel_02Text:SetPoint("CENTER", 0, 0)
Channel_02Text:SetTextColor(255/255, 130/255, 130/255)

function Channel_02_OnClick()
      ChatFrame_OpenChat("/2 ", chatFrame)
end

-- "寻求组队频道(/4)" --
local Channel_04 = CreateFrame("Button", "Channel_04", chat);
Channel_04:SetWidth(23);
Channel_04:SetHeight(23);
Channel_04:SetPoint("topright",ChannelSay,"TOPright",240,0);
Channel_04:RegisterForClicks("AnyUp");
Channel_04:SetScript("OnClick", function() Channel_04_OnClick() end)

Channel_04Text = Channel_04:CreateFontString("Channel_04Text", "OVERLAY")
Channel_04Text:SetFont("fonts\\ARHei.ttf", 15, "OUTLINE")
Channel_04Text:SetJustifyH("CENTER")
Channel_04Text:SetWidth(25)
Channel_04Text:SetHeight(25)
Channel_04Text:SetText("组")
Channel_04Text:SetPoint("CENTER", 0, 0)
Channel_04Text:SetTextColor(210/255, 180/255, 140/255)

function Channel_04_OnClick()
      ChatFrame_OpenChat("/4 ", chatFrame)
end

-- Roll --
local roll = CreateFrame("Button", "rollMacro", UIParent, "SecureActionButtonTemplate")
roll:SetAttribute("*type*", "macro")
roll:SetAttribute("macrotext", "/roll")
roll:SetWidth(23);
roll:SetHeight(23);
roll:SetPoint("topright",ChannelSay,"TOPright",270,0);
rollText =roll:CreateFontString("rollText", "OVERLAY")
rollText:SetFont("fonts\\ARHei.ttf", 15, "OUTLINE")
rollText:SetJustifyH("CENTER")
rollText:SetWidth(25)
rollText:SetHeight(25)
rollText:SetText("骰")
rollText:SetPoint("CENTER", 0, 0)
rollText:SetTextColor(255/255, 255/255, 0/255)

-- "大脚世界频道(/0)" --
local Channel_05 = CreateFrame("Button", "Channel_05", chat);
Channel_05:SetWidth(23);
Channel_05:SetHeight(23);
Channel_05:SetPoint("topright",ChannelSay,"TOPright",300,0);
Channel_05:RegisterForClicks("AnyUp");
Channel_05:SetScript("OnClick", function(self,button) Channel_05_OnClick(self,button) end)

Channel_05Text = Channel_05:CreateFontString("Channel_05Text", "OVERLAY")
Channel_05Text:SetFont("fonts\\ARHei.ttf", 15, "OUTLINE")
Channel_05Text:SetJustifyH("CENTER")
Channel_05Text:SetWidth(25)
Channel_05Text:SetHeight(25)
Channel_05Text:SetText("世")
Channel_05Text:SetPoint("CENTER", 0, 0)
Channel_05Text:SetTextColor(200/255, 255/255, 150/255)

function Channel_05_OnClick(self,button)
   if button == "RightButton" then
     local _, channelName, _  =  GetChannelName("大脚世界频道")
     if channelName == nil then
    JoinPermanentChannel("大脚世界频道", nil, 1, 1)
    ChatFrame_RemoveMessageGroup(ChatFrame1, "CHANNEL")
    ChatFrame_AddChannel(ChatFrame1,"大脚世界频道")
    else
    LeaveChannelByName("大脚世界频道")
    end
   else
     local channel,_,_  = GetChannelName("大脚世界频道")
    ChatFrame_OpenChat("/"..channel.." ", chatFrame)
  end
end
