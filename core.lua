local frame = CreateFrame("FRAME", "Anon")
frame:RegisterEvent("PLAYER_ENTERING_WORLD")
frame:RegisterEvent("ZONE_CHANGED_NEW_AREA")
frame:RegisterEvent("CHAT_MSG_TEXT_EMOTE")

local function eventHandler(self, event, ...)	
	
	
	-- EDIT THIS LINE BELOW TO CHANGE YOUR NAME
	NewName = "Rob"
	PlayerName = GetUnitName("player")
	
	
	
	
	
	
	
	
	
	local inInstance, instanceType = IsInInstance()
	--turn off the 3d-model names above friendly player+pet heads while in unimportant stuff
	if event == "ZONE_CHANED_NEW_AREA" and inInstance and (instanceType == "arena" or instanceType == "raid" or instanceType == "party") then -- keep them off for bgs ("pvp")
		if InCombatLockdown() then return end
		SetCVar("UnitNameFriendlyPlayerName", 1)
		SetCVar("UnitNameFriendlyPetName", 1)
	else
		SetCVar("UnitNameFriendlyPlayerName", 0)
		SetCVar("UnitNameFriendlyPetName", 0)
	end

	-- Change Target's Target UnitFrame Name
	TFTNC = CreateFrame("Frame", "TargetFrameTargetNameChange")
	local function ChangeTargetofTargetName(self)
		local TTN = GetUnitName("targettarget")
		if PlayerName == TTN then
			TargetFrameToT.name:SetText(NewName)
		else TargetFrameToT.name:SetText(UnitClass("targettarget"))
		end
	end
	TFTNC:SetScript("OnUpdate", ChangeTargetofTargetName)

	-- Change Focus UnitFrame Name
	FFNC = CreateFrame("Frame", "FocusFrameNameChange")
	local function ChangeFocusName(self)
		local FN = GetUnitName("focus")
		if PlayerName == FN then
			FocusFrame.name:SetText(NewName)
		end
	end
	FFNC:SetScript("OnUpdate", ChangeFocusName)

	-- Change Focus' Target UnitFrame Name
	FFTNC = CreateFrame("Frame", "FocusFrameTargetNameChange")
	local function ChangeFocusTargetName(self)
		local FTN = GetUnitName("focustarget")
		if PlayerName == FTN then
			FocusFrameToT.name:SetText(NewName)
		end
	end
	FFTNC:SetScript("OnUpdate", ChangeFocusTargetName)
end

	-- Change Player UnitFrame Name
	PFNC = CreateFrame("Frame", "PlayerFrameNameChange")
	local function ChangePlayerName(self)
		PlayerFrame.name:SetText(NewName)
	end
	PFNC:SetScript("OnUpdate", ChangePlayerName)

	-- Change Target UnitFrame Name
	TFNC = CreateFrame("Frame", "TargetFrameNameChange")
	local function ChangeTargetName(self)
		local TN = GetUnitName("target")
		local targetClassName, targetClassFileName, targetClassId = UnitClass("target")
		local player = UnitIsPlayer("target")

		-- Change TargetFrame Name
		if PlayerName == TN then
			TargetFrame.name:SetText(NewName)
		elseif UnitPlayerControlled("target") and targetClassFileName == "WARRIOR" and not player and targetClassId == 1 then
			TargetFrame.name:SetText("Hunter Pet")
		elseif UnitPlayerControlled("target") and (targetClassFileName == "PALADIN" or targetClassFileName == "WARLOCK"	) and not player then
			TargetFrame.name:SetText("Warlock Pet")
		elseif UnitIsPlayer("target") then
			TargetFrame.name:SetText(UnitClass("target"))
		end
		--Class Colored Target Frames
		-- Warrior
		if targetClassId == 1 and player then
			TargetFrameNameBackground:SetVertexColor(0.78,0.61,0.43) --brown
		end

		-- Paladin
		if targetClassId == 2 and player then
			TargetFrameNameBackground:SetVertexColor(0.96, 0.55, 0.73) --Pink
		end

		-- Hunter
		if targetClassId == 3 and player then 
			TargetFrameNameBackground:SetVertexColor(0.67, 0.83, 0.45) --Green
		end

		-- Rogue
		if targetClassId == 4 and player then 
			TargetFrameNameBackground:SetVertexColor(1, 0.96, 0.41) -- Yellow
		end

		-- Priest
		if targetClassId == 5 and player then 
			TargetFrameNameBackground:SetVertexColor(1, 1, 1) --White
		end

		-- Shaman
		if targetClassId == 7 and player then 
			TargetFrameNameBackground:SetVertexColor(0, 0.44, 0.87) --Dark Blue
		end

		-- Mage
		if targetClassId == 8 and player then 
			TargetFrameNameBackground:SetVertexColor(0.41, 0.80, 0.94) --Light Blue
		end

		-- Warlock
		if targetClassId == 9 and player then 
			TargetFrameNameBackground:SetVertexColor(0.58, 0.51,0.79) --Purple
		end

		-- Druid
		if targetClassId == 11 and player then 
			TargetFrameNameBackground:SetVertexColor(1 , 0.49, 0.04) --Orange
		end
	end
	TFNC:SetScript("OnUpdate", ChangeTargetName)
frame:SetScript("OnEvent", eventHandler)


-- Change Tooltip names of players and pets
GameTooltip:HookScript("OnTooltipSetUnit", function(self)
	local targetClassName, targetClassFileName, targetClassId = UnitClass("mouseover")
	local player = UnitIsPlayer("mouseover")

	-- Hunter pet tooltips
	if UnitPlayerControlled("mouseover") and targetClassFileName == "WARRIOR" and not player then 
		GameTooltip:ClearLines()
		GameTooltip:AddLine("Hunter Pet", 1,1,1)
		GameTooltip:AddLine(GameTooltipStatusBar:Show())
	end

	-- Warlock Pet tooltips
	if UnitPlayerControlled("mouseover") and not player and (targetClassFileName == "PALADIN" or targetClassFileName == "WARLOCK") then
		GameTooltip:ClearLines()
		GameTooltip:AddLine("Warlock Pet", 1,1,1)
		GameTooltip:AddLine(GameTooltipStatusBar:Show())
	end

	-- Player tooltips
    if UnitIsPlayer("mouseover") and PlayerName ~= UnitName("mouseover") then 
        GameTooltip:ClearLines()
        GameTooltip:AddLine(UnitClass("mouseover"), 1,1,1)
        if UnitLevel("mouseover") == -1 then
            GameTooltip:AddLine("Level " .. (UnitLevel("player") + 10) .. "+ " .. UnitRace("mouseover") .. " " .. UnitClass("mouseover") .. " (Player)", 1,1,1)
        else
            GameTooltip:AddLine("Level " .. UnitLevel("mouseover") .. " " .. UnitRace("mouseover") .. " " .. UnitClass("mouseover") .. " (Player)", 1,1,1)
        end
        if UnitIsPlayer("mouseover") then
            GameTooltip:AddLine(GameTooltipStatusBar:Show())
        end
        if UnitIsPVP("mouseover") then 
            GameTooltip:AddLine("PvP", 1,1,1)
    	end
	end
end)

--clear tooltip healthbar 
GameTooltip:HookScript("OnTooltipCleared", function()GameTooltip:AddLine(GameTooltipStatusBar:Hide())end)

--Change nameplate name to classname and all pets to Pet
hooksecurefunc("CompactUnitFrame_UpdateName", function(f)
	if f.unit:find("nameplate") then -- pet nameplates
		if f.unit and not UnitIsPlayer(f.unit) and UnitPlayerControlled(f.unit) then
			f.name:SetText("Pet")
			f.name:SetTextColor(1,1,1)
		end
		if f.unit:find("nameplate") then
			if f.unit and UnitIsPlayer(f.unit) then -- player nameplates
				f.name:SetText(UnitClass(f.unit))
				f.name:SetTextColor(1,1,1)
			end
		end	
	end
end)

local emotesToHide = {
	" spits on",
	" rude gesture",
	" slaps",
	" makes some strange gestures",
	" laughs",
	" rolls on the floor laughing",
	" checks your pulse",
	" ruffles your hair",
	" questions",
	" calm",
	" pats",
	" pets",
	" flex",
}
	-- ^^^^^^Removes emotes that contains a message in this list^^^^^
ChatFrame_AddMessageEventFilter("CHAT_MSG_TEXT_EMOTE", function(frame, event, message, sender, ...)
	for i,v in ipairs(emotesToHide) do
		if message:find(v) then
			return true
		end
	end
end)
