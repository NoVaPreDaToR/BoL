--[[
Script Name: Simple Annie
Author: NoVaPreDaToR
]]--

if myHero.charName ~= "Annie" then return end

if FileExist(LIB_PATH .. "/VPrediction.lua") then
	require ("VPrediction")
	VP = VPrediction()
end

local AnnieVersion = 0.1
local ts
local SACLoaded, SxOrbLoaded = false, false
local target = nil


function OnLoad()

	CheckOrbWalker()
		
	Config = scriptConfig("Simple Annie", "NovaAnnie")
	
	Config:addSubMenu("Drawings", "draws")
		Config.draws:addParam("aaRange", "AA-Range", SCRIPT_PARAM_ONOFF, true)
		Config.draws:addParam("qRange", "Q & W-Range", SCRIPT_PARAM_ONOFF, true)
		Config.draws:addParam("rRange", "Ult-Range", SCRIPT_PARAM_ONOFF, true)
	
	Config:addSubMenu("Keybinds", "keys")
		Config.keys:addParam("comboMode", "Combo", SCRIPT_PARAM_ONKEYDOWN, false, string.byte(" "))
		Config.keys:addParam("harassMode", "Harass", SCRIPT_PARAM_ONKEYDOWN, false, string.byte("C"))
		
	Config:addSubMenu("Combo Settings", "combo")
		Config.combo:addParam("useQ", "Use Q in Combo", SCRIPT_PARAM_ONOFF, true)
		Config.combo:addParam("useW", "Use W in Combo", SCRIPT_PARAM_ONOFF, true)
		Config.combo:addParam("useR", "Use R in Combo", SCRIPT_PARAM_ONOFF, true)
		Config.combo:addSubMenu("Autoult Settings", "autoult")
			Config.combo.autoult:addParam("useAutoult", "Use Autoult", SCRIPT_PARAM_ONOFF, true)
			Config.combo.autoult:addParam("minR", "Minimum enemies to ultimate on", SCRIPT_PARAM_SLICE, 1, 1, 5, 0)
		
	Config:addSubMenu("Harass Settings", "harass")
		Config.combo:addParam("useQ", "Use Q in Harass", SCRIPT_PARAM_ONOFF, true)
		Config.combo:addParam("useW", "Use W in Harass", SCRIPT_PARAM_ONOFF, true)
		
	Config:addSubMenu("Passive Settings", "passive")
		Config.passive:addParam("ultPassive", "Only Ult with Passive", SCRIPT_PARAM_ONOFF, true)
		Config.passive:addParam("useE", "Use E to gain Passive stacks", SCRIPT_PARAM_ONOFF, false)
		
	Config:addSubMenu("Orbwalker", "orbwalker")
	
	Config:addParam("ver", "Version", SCRIPT_PARAM_INFO, AnnieVersion)
	Config:addParam("author", "Author", SCRIPT_PARAM_INFO, "NoVaPreDaToR")
	
	ts = TargetSelector(TARGET_LOW_HP_PRIORITY, 1000)
	
	
	PrintChat("<font color = \"#ff9900\">Loaded</font> <font color = \"#ff0000\">[Simple Annie]</font> <font color = \"#ff9900\">Version: "..AnnieVersion.."</font>!")
	PrintChat("<font color = \"#ff9900\">by NoVaPreDaToR</font>")
end

function CheckOrbWalker()
	if _G.Reborn_Initialised then
		SACLoaded = true
		Config.orbwalker:addParam("info", "SAC detected", SCRIPT_PARAM_INFO, "")
		_G.AutoCarry.Skills:DisableAll()
		Say("SAC Detected")
	elseif FileExist(LIB_PATH .. "SxOrbWalk.lua") then
		require ("SxOrbWalk")
		SxOrbLoaded = true
		_G.SxOrb:LoadToMenu(Config.orbwalker)
		Say("SAC not detected, SxOrb loaded")
	end
end

function onTick()
	target = GetOrbTarget()
	
	if Config.keys.comboMode then
		ComboMode()
	end
	
	if Config.keys.harassMode then
		HarassMode()
	end
end

function GetOrbTarget()
	ts:update()
	if SACLoaded then return _G.AutoCarry.Crosshair:GetTarget() end
	if SxOrbLoaded then return _G.SxOrb:GetTarget() end
	return ts.target
end

function ComboMode()
	if Config.keys.comboMode then
		if ts.target ~= nil and ValidTarget(target, 625) and Config.combo.useQ then
			CastQ(target)
		end
		
		if ts.target ~= nil and ValidTarget(target, 625) and Config.combo.useW then
			CastW(target)
		end
	end
end

function HarassMode()
	if Config.keys.harassMode then
		if ts.target ~= nil and ValidTarget(target, 625) and Config.harass.useQ then
			CastQ(target)
		end
		
		if ts.target ~= nil and ValidTarget(target, 625) and Config.harass.useW then
			CastW(target)
		end
	end
end

function CastQ(target)
	if (myHero:CanUseSpell(_Q) == READY) and not myHero.dead then
		CastSpell(_Q, target)
	end
end

function CastW(target)
	if (myHero:CanUseSpell(_W) == READY) and not myHero.dead then
		CastSpell(_W, target)
	end
end

function OnDraw()
	if Config.draws.aaRange then
		DrawCircle(myHero.x, myHero.y, myHero.z, myHero.range + GetDistance(myHero, myHero.minBBox), ARGB(255, 0, 255, 0))
	end
	
	if Config.draws.qRange then
		DrawCircle(myHero.x, myHero.y, myHero.z, 625, 0x111111)
	end
	
	if Config.draws.rRange then
		DrawCircle(myHero.x, myHero.y, myHero.z, 600, 0x111111)
	end
end

