local frame = CreateFrame("FRAME", "Anon")
frame:RegisterEvent("PLAYER_ENTERING_WORLD")
frame:RegisterEvent("ZONE_CHANGED_NEW_AREA")
frame:RegisterEvent("CHAT_MSG_TEXT_EMOTE")
-- turn on nameplate classcolors
SetCVar("ShowClassColorInNameplate", 1) -- change 1 to 0 if you want to turn it off

local function eventHandler(self, event, ...)

	-- EDIT THIS LINE BELOW TO CHANGE YOUR NAME
	NewName = ""
	PlayerName = GetUnitName("player")


	


	




	 ClassColors = {
		{0.78, 0.61, 0.43}, -- brown
		{0.96, 0.55, 0.73}, -- Pink
		{0.67, 0.83, 0.45}, --Green
		{1, 0.96, 0.41}, --Yellow
		{1,1,1}, --white
		{0, 0.44, 0.87}, --darkblue
		{0, 0.44, 0.87}, --placeholder
		{0.41, 0.80, 0.94}, --lightblue
		{0.58, 0.51,0.79}, --purple
		{0.58, 0.51,0.79}, --placeholder
		{1, 0.49, 0.04} --orange
	}

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
		local focusClassName, focusClassFileName, focusClassId = UnitClass("focus")
		local FN = GetUnitName("focus")
		local player = UnitIsPlayer("focus")
		local function focusVertexColor(r,g,b)
			FocusFrameNameBackground:SetVertexColor(r,g,b)
		end
		-- Class-Colored Focus Frame
		for i=1,11 do
			local r
			local g
			local b
			if i ~= 6 and i ~= 10 then
				for j=1,3 do
					if j == 1 then
						r = ClassColors[i][j]
					end
					if j == 2 then	
						g = ClassColors[i][j]
					end
					if j == 3 then
						b = ClassColors[i][j]
					end
				end
				if focusClassId == i and player then
					focusVertexColor(r,g,b)
				end
			end
		end

		if UnitCreatureType("focus") == "Beast" and UnitPlayerControlled("focus") then
			FocusFrame.name:SetText("Hunter Pet")
		end
		if UnitCreatureType("focus") == "Totem" then
			FocusFrame.name:SetText(GetUnitName("focus"))
		end
		if player then	
			FocusFrame.name:SetText(UnitClass("focus"))
		end
		if PlayerName == FN then
			FocusFrame.name:SetText(NewName)
		end
		--show arena numbers on focus
		for i=1,5 do
			if UnitIsUnit("focus","arena"..i) then
				FocusFrame.name:SetText(UnitClass("arena"..i) .. " " .. i)
			end
		end
	end
	FFNC:SetScript("OnUpdate", ChangeFocusName)

	-- Change Focus' Target UnitFrame Name
	FFTNC = CreateFrame("Frame", "FocusFrameTargetNameChange")
	local function ChangeFocusTargetName(self)
		local FTN = GetUnitName("focustarget")
		if PlayerName == FTN then
			FocusFrameToT.name:SetText(NewName)
		else FocusFrameToT.name:SetText(UnitClass("focustarget"))
		end
	end
	FFTNC:SetScript("OnUpdate", ChangeFocusTargetName)
end

-- Change Player UnitFrame Name
PFNC = CreateFrame("Frame", "PlayerFrameNameChange")
local function ChangePlayerName(self)
	PlayerFrame.name:SetText(NewName)
	--hides pet name if exists
	if UnitExists("pet") then
		PetName:Hide()
	end
end
PFNC:SetScript("OnUpdate", ChangePlayerName)

-- Change Target UnitFrame Name
TFNC = CreateFrame("Frame", "TargetFrameNameChange")
local function ChangeTargetName(self)
	local TN, _ = GetUnitName("target")
	local targetClassName, targetClassFileName, targetClassId = UnitClass("target")
	local player = UnitIsPlayer("target")

		-- Change TargetFrame Name
		if TN == PlayerName then
			TargetFrame.name:SetText(NewName)
		elseif UnitPlayerControlled("target") and UnitCreatureType("target") == "Beast" and not player then
			TargetFrame.name:SetText("Hunter Pet")
			TargetFrameNameBackground:SetVertexColor(0.67, 0.83, 0.45) -- green
		else
			if player then
				TargetFrame.name:SetText(UnitClass("target"))	
			end
		end	
	-- places arena numbers on targets
		for i=1,5 do
			if UnitIsUnit("target","arena"..i) then
				TargetFrame.name:SetText(UnitClass("arena"..i) .. " " .. i)
			elseif UnitIsUnit("target", "party"..i) then
				TargetFrame.name:SetText(UnitClass("party"..i) .. " " .. i)
			end
		end
	

	local function targetVertexColor(r,g,b)
		TargetFrameNameBackground:SetVertexColor(r,g,b)
	end
	-- Class-Colored Player Target Frame
	for i=1,11 do
		local r
		local g
		local b
		if i ~= 6 and i ~= 10 then
			for j=1,3 do
				if j == 1 then
					r = ClassColors[i][j]
				end
				if j == 2 then
					g = ClassColors[i][j]
				end
				if j == 3 then
					b = ClassColors[i][j]
				end
			end
			if targetClassId == i and player then
				targetVertexColor(r,g,b)
			end
		end
	end
end
TFNC:SetScript("OnUpdate", ChangeTargetName)
frame:SetScript("OnEvent", eventHandler)



	-- Change Tooltip from names of players to classes and changes pet names
GameTooltip:HookScript("OnTooltipSetUnit", function(self)
	local targetClassName, _, _ = UnitClass("mouseover")
	local player = UnitIsPlayer("mouseover")

	local function AddLine(line)
		GameTooltip:AddLine(line, 1,1,1)
	end

	-- Hunter pet tooltip
	if UnitPlayerControlled("mouseover") and UnitCreatureType("mouseover") == "Beast" and not player then 
		GameTooltip:ClearLines()
		AddLine("Hunter Pet")
		GameTooltip:AddLine(GameTooltipStatusBar:Show())
	end

	-- Warlock Pet tooltips
	local pets = {
		"Succubus", "Imp", "Voidwalker", "Felhunter"
	}
	for i=1,#pets do
		if UnitCreatureFamily("mouseover") == pets[i] then
			GameTooltip:ClearLines()
			AddLine(pets[i])
			GameTooltip:AddLine(GameTooltipStatusBar:Show())
		end
	end

	-- Shaman Totems
	if UnitCreatureType("mouseover") == "Totem" then
		GameTooltip:ClearLines()
		AddLine(GetUnitName("mouseover"))
		GameTooltip:AddLine(GameTooltipStatusBar:Show())
	end

	--Mage Pet tooltip
	if UnitPlayerControlled("mouseover") and targetClassName == "Water Elemental" then
		GameTooltip:ClearLines()
		AddLine("Water Elemental")
		GameTooltip:AddLine(GameTooltipStatusBar:Show())
	end

	-- Player tooltips
    if UnitIsPlayer("mouseover") and PlayerName ~= UnitName("mouseover") then 
        GameTooltip:ClearLines()
        AddLine(UnitClass("mouseover"))
        if UnitLevel("mouseover") == -1 then
            AddLine("Level " .. (UnitLevel("player") + 10) .. "+ " .. UnitRace("mouseover") .. " " .. UnitClass("mouseover") .. " (Player)")
        else
            AddLine("Level " .. UnitLevel("mouseover") .. " " .. UnitRace("mouseover") .. " " .. UnitClass("mouseover") .. " (Player)")
        end
        if UnitIsPlayer("mouseover") then
            GameTooltipStatusBar:Show()
        end
        if UnitIsPVP("mouseover") then 
            AddLine("PvP", 1,1,1)
    	end
	end
end)

--clear tooltip healthbar 
GameTooltip:HookScript("OnTooltipCleared", function()GameTooltip:AddLine(GameTooltipStatusBar:Hide())end)

--Change nameplate name to classname and all pets to Pet
hooksecurefunc("CompactUnitFrame_UpdateName",function(f)
	local player = UnitIsPlayer(f.unit)
	local pets = {
		"Succubus", "Imp", "Voidwalker", "Felhunter"
	}
	local className, classFileName, classId = UnitClass(f.unit)
	if f.unit:find("nameplate") then -- pet nameplates
		f.healthBar.border:Hide()
		if f.unit and not UnitIsPlayer(f.unit) and UnitPlayerControlled(f.unit) and UnitCreatureType(f.unit) == "Beast" then
			f.name:SetText("Hunter Pet")
			f.name:SetTextColor(1,1,1)
			f.healthBar:SetStatusBarColor(0.67, 0.83, 0.45) -- green
		end
		if className == "Water Elemental" then
			f.healthBar:SetStatusBarColor(0.41, 0.80, 0.94) -- light blue
		end


		if f.unit and UnitCreatureType(f.unit) == "Totem" then
			f.name:SetText(GetUnitName(f.unit))
		end
		for i=1,#pets do
			if f.unit and UnitCreatureFamily(f.unit) == pets[i] then
				f.name:SetText(pets[i])
				f.name:SetTextColor(1,1,1)
			end
		end
			if f.unit and UnitIsPlayer(f.unit) then -- player nameplates
				local className, classFileName, classId = UnitClass(f.unit)
				local function healthBarColor(r,g,b)
					f.healthBar:SetStatusBarColor(r,g,b)
				end
				f.name:SetText(UnitClass(f.unit))
				f.name:SetTextColor(1,1,1)
				--places arena numbers for nameplates
				for i=1,5 do
					if UnitIsUnit(f.unit,"arena"..i) then
						f.name:SetText(UnitClass(f.unit) .. " " .. i)
						f.name:SetTextColor(1,1,0) 
					end 
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
	" cheers",
	" licks",
	" barks",
	" yawn",
}
	-- ^^^^^^Removes emotes that contains a message in this list^^^^^
ChatFrame_AddMessageEventFilter("CHAT_MSG_TEXT_EMOTE", function(frame, event, message, sender, ...)
	for i,v in ipairs(emotesToHide) do 
		if message:find(v) then
			return true
		end
	end
end)
