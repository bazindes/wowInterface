local Misc = CreateFrame("Frame")
local Media = "Interface\\AddOns\\ShestakUI_Filger\\Media\\"
Misc.Media = Media

-- ShestakUI_Filger.lua
-- ��ѡ��ɫ: "DK", "DLY"-С��, "LR", "FS", "WS"-��ɮ, "QS", "MS"-��ʦ(�Ȱ�ɫ), "DZ", "SM", "SS", "ZS", "Black"-��ɫ, "Gray"-��ɫ, "OWN"-�Զ�ѡ���㵱ǰ��ɫ��ְҵ��ɫ.
Misc.font = Media.."Pixel.ttf"	-- �������ֵ�����
Misc.barfg = Media.."White"		-- ��ʱ������
Misc.modefg = "OWN"				-- ��ʱ����ɫ
--Misc.modeback = "OWN"			-- ͼ�걳�����ɰ���ɫ(һ���غ�ë������ʽ��Ч)
Misc.modeborder = "Black"		-- �߿���ɫ
Misc.numsize = 12				-- ����, ��ʱ���ļ�ʱ���ִ�С
Misc.namesize = 14				-- �������������С
Misc.maxTestIcon = 5			-- ����ģʽÿ����ʾͼ������

-- Cooldowns.lua
Misc.cdsize = 16				-- ͼ���м�� CD ���ִ�С

-- Spells.lua
Misc.Tbar = "ON"				-- ��(ON)\��(OFF) target_bar Ŀ���ʱ�� - (��ͼ��ע�� 9)
Misc.Pbar = "ON"				-- ��(ON)\��(OFF) pve_cc ��ʱ�� - (��ͼ��ע�� 7)
Misc.CD = "ON"					-- ��(ON)\��(OFF) COOLDOWN ��ȴͼ�� - (��ͼ��ע�� 8)
Misc.barw = 160					-- ��ʱ������ - (��ͼ��ע�� 7,9)
Misc.CDnum = 8					-- COOLDOWN ��ȴͼ��ÿ����ʾ���� - (��ͼ��ע�� 8)
Misc.IconSize = 38				-- ͼ���С - (��ͼ��ע�� 1,2,3,4)
Misc.BigIconSize = 64			-- ��ͼ�� - (��ͼ��ע�� 5,6)
Misc.CDIconSize = 32			-- COOLDOWN ��ȴͼ���С - (��ͼ��ע�� 8)
Misc.barIconSize = 26			-- ��ʱ���ϵ�ͼ���С - (��ͼ��ע�� 7,9)
Misc.Interval = 3				-- ���

-------------------------------------------------------- 
--   Pixel perfect script of custom ui Scale
local resolution = ({GetScreenResolutions()})[GetCurrentResolution()] or GetCVar("gxWindowedResolution")

UIScale = function()
   uiscale = min(2, max(0.64, 768 / string.match(resolution, "%d+x(%d+)")))
end
UIScale()

local mult = 768 / string.match(resolution, "%d+x(%d+)") / uiscale
local Scale = function(x)
   return mult * math.floor(x / mult + 0.5)
end
Misc.mult = mult
----------------------- ShestakUI_Filger_1px -----------------------

-- ����
local _, ns = ...
ns.Misc = Misc

-- λ��
if IsAddOnLoaded("ShestakUI") then
	local T, C, L, _ = unpack(ShestakUI)
	if _G.oUF_Player then
		 FilgerPositions = {
			player_buff_icon = {"BOTTOMRIGHT", "oUF_Player", "TOPRIGHT", 2, 173},	-- "P_BUFF_ICON"
			player_proc_icon = {"BOTTOMLEFT", "oUF_Target", "TOPLEFT", -2, 173},	-- "P_PROC_ICON"
			special_proc_icon = {"BOTTOMRIGHT", "oUF_Player", "TOPRIGHT", 2, 213},	-- "SPECIAL_P_BUFF_ICON"
			target_debuff_icon = {"BOTTOMLEFT", "oUF_Target", "TOPLEFT", -2, 213},	-- "T_DEBUFF_ICON"
			target_buff_icon = {"BOTTOMLEFT", "oUF_Target", "TOPLEFT", -2, 253},	-- "T_BUFF"
			pve_debuff = {"BOTTOMRIGHT", "oUF_Player", "TOPRIGHT", 2, 253},			-- "PVE/PVP_DEBUFF"
			pve_cc = {"TOPLEFT", "oUF_Player", "BOTTOMLEFT", -2, -50},				-- "PVE/PVP_CC"
			cooldown = {"BOTTOMRIGHT", "oUF_Player", "TOPRIGHT", 63, C.unitframe.plugins_swing and 29 or 17},		-- "COOLDOWN"
			target_bar = {"BOTTOMLEFT", C.unitframe.portrait_enable and "oUF_Target_Portrait" or "oUF_Target", "BOTTOMRIGHT", C.unitframe.portrait_enable and 6 or 9, C.unitframe.portrait_enable and -3 or -41},	-- "T_DE/BUFF_BAR"
		}
	end
else
	-- ����(���ε��� λ��,ͼ���С��, �������¥�ö��ı�עͼ)
	FilgerPositions = {
		player_buff_icon = {"BOTTOMRIGHT", UIParent, "CENTER", -180, -80},	-- "P_BUFF_ICON"		(player_buff_icon λ������ - ��ͼ��ע�� 1)
		player_proc_icon = {"BOTTOMLEFT", UIParent, "CENTER", 180, -80},	-- "P_PROC_ICON"		(player_proc_icon λ������ - ��ͼ��ע�� 2)
		special_proc_icon = {"BOTTOMRIGHT", UIParent, "CENTER", -180, -40},	-- "SPECIAL_P_BUFF_ICON"	(special_proc_icon λ������ - ��ͼ��ע�� 3)
		target_debuff_icon = {"BOTTOMLEFT", UIParent, "CENTER", 180, -40},	-- "T_DEBUFF_ICON"		(target_debuff_icon λ������ - ��ͼ��ע�� 4)
		target_buff_icon = {"BOTTOMLEFT", UIParent, "CENTER", 180, 0},		-- "T_BUFF"				(target_buff_icon λ������ - ��ͼ��ע�� 5)
		pve_debuff = {"BOTTOMRIGHT", UIParent, "CENTER", -180, 0},			-- "PVE/PVP_DEBUFF"		(pve_debuff λ������ - ��ͼ��ע�� 6)
		pve_cc = {"TOPLEFT", UIParent, "LEFT", 50, 0},						-- "PVE/PVP_CC"			(pve_cc λ������ - ��ͼ��ע�� 7)
		cooldown = {"TOPLEFT", UIParent, "CENTER", -90, -120},				-- "COOLDOWN"			(cooldown λ������ - ��ͼ��ע�� 8)
		target_bar = {"TOPRIGHT", UIParent, "RIGHT", -260, 0},				-- "T_DE/BUFF_BAR"		(target_bar λ������ - ��ͼ��ע�� 9)
	}
end