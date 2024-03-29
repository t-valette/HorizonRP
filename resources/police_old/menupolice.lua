-----------------------------------------------------------------------------------------------------------------
----------------------------------------------------POLICE MENU--------------------------------------------------
-----------------------------------------------------------------------------------------------------------------

local buttonsCitizen = {}

if(config.useGcIdentity == true) then
	buttonsCitizen[1] = {name = "Carte d'identité", description = ''}
end

if(config.useVDKInventory == true or config.useWeashop == true) then
	buttonsCitizen[#buttonsCitizen+1] = {name = "Fouiller", description = ''}
end

buttonsCitizen[#buttonsCitizen+1] = {name = "(De)Menotter", description = ''}
buttonsCitizen[#buttonsCitizen+1] = {name = "Mettre dans le véhicule", description = ''}
buttonsCitizen[#buttonsCitizen+1] = {name = "Faire sortir du véhicule", description = ''}
buttonsCitizen[#buttonsCitizen+1] = {name = "Escorter le joueur", description = ''}
buttonsCitizen[#buttonsCitizen+1] = {name = "Amendes", description = ''}


local buttonsVehicle = {}

if(config.enableCheckPlate == true) then
	buttonsVehicle[1] = {name = "Plaque d'immatriculation", description = ''}
end

buttonsVehicle[#buttonsVehicle+1] = {name = "Crocheter le véhicule", description = ''}

local menupolice = {
	opened = false,
	title = "Menu Police",
	currentmenu = "main",
	lastmenu = nil,
	currentpos = nil,
	selectedbutton = 0,
	marker = { r = 0, g = 155, b = 255, a = 200, type = 1 },
	menu = {
		x = 0.11,
		y = 0.25,
		width = 0.2,
		height = 0.04,
		buttons = 10,
		from = 1,
		to = 10,
		scale = 0.4,
		font = 0,
		["main"] = {
			title = "CATEGORIES",
			name = "main",
			buttons = {
				{name = "Animations", description = ""},
				{name = "Citoyen", description = ""},
				{name = "Véhicule", description = ""},
				{name = "Fermer le Menu", description = ""},
			}
		},
		["Animations"] = {
			title = "ANIMATIONS",
			name = "Animations",
			buttons = {
				{name = "Faire la circulation", description = ''},
				{name = "Prendre des notes", description = ''},
				{name = "Stand By", description = ''},
				{name = "Stand By 2", description = ''},
			}
		},
		["Citoyen"] = {
			title = "INTERACTION CITOYEN",
			name = "Citoyen",
			buttons = buttonsCitizen
		},
		["Amendes"] = {
			title = "AMENDES",
			name = "Amendes",
			buttons = {
				{name = "$250", description = ''},
				{name = "$500", description = ''},
				{name = "$1000", description = ''},
				{name = "$1500", description = ''},
				{name = "$2000", description = ''},
				{name = "$4000", description = ''},
				{name = "$6000", description = ''},
				{name = "$8000", description = ''},
				{name = "$10000", description = ''},
				{name = "Autre montant", description = ''},
			}
		},
		["Véhicule"] = {
			title = "INTERACTION VEHICULE",
			name = "Véhicule",
			buttons = buttonsVehicle
		},
	}
}

-------------------------------------------------
----------------BUTTONS FUNCTIONS----------------
-------------------------------------------------

function ButtonSelectedPolice(button)
	local ped = GetPlayerPed(-1)
	local this = menupolice.currentmenu
	local btn = button.name
	if this == "main" then
		if btn == "Animations" then
			OpenMenuPolice('Animations')
		elseif btn == "Citoyen" then
			OpenMenuPolice('Citoyen')
		elseif btn == "Véhicule" then
			OpenMenuPolice('Véhicule')
		elseif btn == "Fermer le Menu" then
			CloseMenuPolice()
		end
	elseif this == "Animations" then
		if btn == "Faire la circulation" then
			DoTraffic()
		elseif btn == "Prendre des notes" then
			Note()
		elseif btn == "Stand By" then
			StandBy()
		elseif btn == "Stand By 2" then
			StandBy2()
		end
	elseif this == "Citoyen" then
		if btn == "Amendes" then
			OpenMenuPolice('Amendes')
		elseif btn == "Fouiller" then
			CheckInventory()
		elseif btn == "(De)Menotter" then
			ToggleCuff()
		elseif btn == "Mettre dans le véhicule" then
			PutInVehicle()
		elseif btn == "Faire sortir du véhicule" then
			UnseatVehicle()
		elseif btn == "Escorter le joueur" then
			DragPlayer()
		elseif btn == "Carte d'identité" then
			CheckId()
		end
	elseif this == "Véhicule" then
		if btn == "Crocheter le véhicule"then
			Crochet()
		elseif btn == "Plaque d'immatriculation" then
			CheckPlate()
		end
	elseif this == "Amendes" then
		if btn == "$250"then
			Fines(250)
		elseif btn == "$500" then
			Fines(500)
		elseif btn == "$1000" then
			Fines(1000)
		elseif btn == "$1500" then
			Fines(1500)
		elseif btn == "$2000" then
			Fines(2000)
		elseif btn == "$4000" then
			Fines(4000)
		elseif btn == "$6000" then
			Fines(6000)
		elseif btn == "$8000" then
			Fines(8000)
		elseif btn == "$10000" then
			Fines(10000)
		elseif btn == "Autre montant" then
			Fines(-1)
		end
	end
end

-------------------------------------------------
---------------ANIMATIONS FUNCTIONS--------------
-------------------------------------------------

function DoTraffic()
	Citizen.CreateThread(function()
        TaskStartScenarioInPlace(GetPlayerPed(-1), "WORLD_HUMAN_CAR_PARK_ATTENDANT", 0, false)
        Citizen.Wait(60000)
        ClearPedTasksImmediately(GetPlayerPed(-1))
    end)
	drawNotification("~g~Vous faites la circulation.")
end

function Note()
	Citizen.CreateThread(function()
        TaskStartScenarioInPlace(GetPlayerPed(-1), "WORLD_HUMAN_CLIPBOARD", 0, false)
        Citizen.Wait(20000)
        ClearPedTasksImmediately(GetPlayerPed(-1))
    end) 
	drawNotification("~g~Vous prenez des notes.")
end

function StandBy()
	Citizen.CreateThread(function()
        TaskStartScenarioInPlace(GetPlayerPed(-1), "WORLD_HUMAN_COP_IDLES", 0, true)
        Citizen.Wait(20000)
        ClearPedTasksImmediately(GetPlayerPed(-1))
    end)
	drawNotification("~g~Vous êtes en Stand By.")
end

function StandBy2()
	Citizen.CreateThread(function()
        TaskStartScenarioInPlace(GetPlayerPed(-1), "WORLD_HUMAN_GUARD_STAND", 0, 1)
        Citizen.Wait(20000)
        ClearPedTasksImmediately(GetPlayerPed(-1))
    end)
	drawNotification("~g~Vous êtes en Stand By.")
end

-------------------------------------------------
-----------------CITIZENS FUNCTIONS--------------
-------------------------------------------------

function CheckInventory()
	local t, distance = GetClosestPlayer()
	if(distance ~= -1 and distance < 3) then
		TriggerServerEvent("police:targetCheckInventory", GetPlayerServerId(t))
	else
		TriggerEvent('chatMessage', 'GOVERNMENT', {255, 0, 0}, "No player near you !")
	end
end

function CheckId()
	local t , distance  = GetClosestPlayer()
    if(distance ~= -1 and distance < 3) then
		TriggerServerEvent('gc:copOpenIdentity', GetPlayerServerId(t))
    else
		TriggerEvent('chatMessage', 'GOVERNMENT', {255, 0, 0}, "No player near you !")
	end
end

function ToggleCuff()
	local t, distance = GetClosestPlayer()
	if(distance ~= -1 and distance < 3) then
		TriggerServerEvent("police:cuffGranted", GetPlayerServerId(t))
	else
		TriggerEvent('chatMessage', 'GOVERNMENT', {255, 0, 0}, "No player near you (maybe get closer) !")
	end
end

function PutInVehicle()
	local t, distance = GetClosestPlayer()
	if(distance ~= -1 and distance < 3) then
		local v = GetVehiclePedIsIn(GetPlayerPed(-1), true)
		TriggerServerEvent("police:forceEnterAsk", GetPlayerServerId(t), v)
	else
		TriggerEvent('chatMessage', 'SYSTEM', {255, 0, 0}, "No player near you (maybe get closer) !")
	end
end

function UnseatVehicle()
	local t, distance = GetClosestPlayer()
	if(distance ~= -1 and distance < 3) then
		TriggerServerEvent("police:confirmUnseat", GetPlayerServerId(t))
	else
		TriggerEvent('chatMessage', 'SYSTEM', {255, 0, 0}, "No player near you (maybe get closer) !")
	end
end

function DragPlayer()
	local t, distance = GetClosestPlayer()
	if(distance ~= -1 and distance < 3) then
		TriggerServerEvent("police:dragRequest", GetPlayerServerId(t))
	else
		TriggerEvent('chatMessage', 'SYSTEM', {255, 0, 0}, "No player near you (maybe get closer) !")
	end
end

function Fines(amount)
	local t, distance = GetClosestPlayer()
	if(distance ~= -1 and distance < 3) then
		if(amount == -1) then
			DisplayOnscreenKeyboard(1, "FMMC_KEY_TIP8S", "", "", "", "", "", 20)
			while (UpdateOnscreenKeyboard() == 0) do
				DisableAllControlActions(0);
				Wait(0);
			end
			if (GetOnscreenKeyboardResult()) then
				local res = tonumber(GetOnscreenKeyboardResult())
				if(res ~= nil and res ~= 0) then
					amount = res				
				end
			end
		end
		
		if(amount ~= -1) then
			TriggerServerEvent("police:finesGranted", GetPlayerServerId(t), amount)
		end
	else
		TriggerEvent('chatMessage', 'SYSTEM', {255, 0, 0}, "No player near you (maybe get closer) !")
	end
end

-------------------------------------------------
-----------------VEHICLES FUNCTIONS--------------
-------------------------------------------------

function Crochet()
	Citizen.CreateThread(function()
	local ply = GetPlayerPed(-1)
	local plyCoords = GetEntityCoords(ply, 0)
	--GetClosestVehicle(x,y,z,distance dectection, 0 = tous les vehicules, Flag 70 = tous les veicules sauf police a tester https://pastebin.com/kghNFkRi)
	veh = GetClosestVehicle(plyCoords["x"], plyCoords["y"], plyCoords["z"], 5.001, 0, 70)
	TaskStartScenarioInPlace(GetPlayerPed(-1), "WORLD_HUMAN_WELDING", 0, true)
	Citizen.Wait(20000)
    SetVehicleDoorsLocked(veh, 1)
	ClearPedTasksImmediately(GetPlayerPed(-1))
	drawNotification("Le véhicule est ~g~ouvert~w~.")
	end)
end

function CheckPlate()
	local pos = GetEntityCoords(GetPlayerPed(-1))
	local entityWorld = GetOffsetFromEntityInWorldCoords(GetPlayerPed(-1), 0.0, 20.0, 0.0)

	local rayHandle = CastRayPointToPoint(pos.x, pos.y, pos.z, entityWorld.x, entityWorld.y, entityWorld.z, 10, GetPlayerPed(-1), 0)
	local a, b, c, d, vehicleHandle = GetRaycastResult(rayHandle)
	if(DoesEntityExist(vehicleHandle)) then
		TriggerServerEvent("police:checkingPlate", GetVehicleNumberPlateText(vehicleHandle))
	else
		TriggerEvent('chatMessage', 'SYSTEM', {255, 0, 0}, "No vehicle near you (maybe get closer) !")
	end
end
-------------------------------------------------
----------------CONFIG OPEN MENU-----------------
-------------------------------------------------

function OpenMenuPolice(menu)
	menupolice.lastmenu = menupolice.currentmenu
	if menu == "Animations" then
		menupolice.lastmenu = "main"
	elseif menu == "Citoyen" then
		menupolice.lastmenu = "main"
	elseif menu == "Véhicule" then
		menupolice.lastmenu = "main"
	elseif menu == "Amendes" then
		menupolice.lastmenu = "main"
	end
	menupolice.menu.from = 1
	menupolice.menu.to = 10
	menupolice.selectedbutton = 0
	menupolice.currentmenu = menu
end

-------------------------------------------------
------------------DRAW NOTIFY--------------------
-------------------------------------------------
function drawNotification(text)
	SetNotificationTextEntry("STRING")
	AddTextComponentString(text)
	DrawNotification(false, false)
end

--------------------------------------
-------------DISPLAY HELP TEXT--------
--------------------------------------

function DisplayHelpText(str)
	SetTextComponentFormat("STRING")
	AddTextComponentString(str)
	DisplayHelpTextFromStringLabel(0, 0, 1, -1)
end

-------------------------------------------------
------------------DRAW TITLE MENU----------------
-------------------------------------------------

function drawMenuTitle(txt,x,y)
local menu = menupolice.menu
	SetTextFont(2)
	SetTextProportional(0)
	SetTextScale(0.5, 0.5)
	SetTextColour(255, 255, 255, 255)
	SetTextEntry("STRING")
	AddTextComponentString(txt)
	DrawRect(x,y,menu.width,menu.height,0,0,0,150)
	DrawText(x - menu.width/2 + 0.005, y - menu.height/2 + 0.0028)
end

-------------------------------------------------
------------------DRAW MENU BOUTON---------------
-------------------------------------------------

function drawMenuButton(button,x,y,selected)
	local menu = menupolice.menu
	SetTextFont(menu.font)
	SetTextProportional(0)
	SetTextScale(menu.scale, menu.scale)
	if selected then
		SetTextColour(0, 0, 0, 255)
	else
		SetTextColour(255, 255, 255, 255)
	end
	SetTextCentre(0)
	SetTextEntry("STRING")
	AddTextComponentString(button.name)
	if selected then
		DrawRect(x,y,menu.width,menu.height,255,255,255,255)
	else
		DrawRect(x,y,menu.width,menu.height,0,0,0,150)
	end
	DrawText(x - menu.width/2 + 0.005, y - menu.height/2 + 0.0028)
end

-------------------------------------------------
------------------DRAW MENU INFO-----------------
-------------------------------------------------

function drawMenuInfo(text)
	local menu = menupolice.menu
	SetTextFont(menu.font)
	SetTextProportional(0)
	SetTextScale(0.45, 0.45)
	SetTextColour(255, 255, 255, 255)
	SetTextCentre(0)
	SetTextEntry("STRING")
	AddTextComponentString(text)
	DrawRect(0.675, 0.95,0.65,0.050,0,0,0,150)
	DrawText(0.365, 0.934)
end

-------------------------------------------------
----------------DRAW MENU DROIT------------------
-------------------------------------------------

function drawMenuRight(txt,x,y,selected)
	local menu = menupolice.menu
	SetTextFont(menu.font)
	SetTextProportional(0)
	SetTextScale(menu.scale, menu.scale)
	--SetTextRightJustify(1)
	if selected then
		SetTextColour(0, 0, 0, 255)
	else
		SetTextColour(255, 255, 255, 255)
	end
	SetTextCentre(0)
	SetTextEntry("STRING")
	AddTextComponentString(txt)
	DrawText(x + menu.width/2 - 0.03, y - menu.height/2 + 0.0028)
end

-------------------------------------------------
-------------------DRAW TEXT---------------------
-------------------------------------------------

function drawTxt(text,font,centre,x,y,scale,r,g,b,a)
	SetTextFont(font)
	SetTextProportional(0)
	SetTextScale(scale, scale)
	SetTextColour(r, g, b, a)
	SetTextDropShadow(0, 0, 0, 0,255)
	SetTextEdge(1, 0, 0, 0, 255)
	SetTextDropShadow()
	SetTextOutline()
	SetTextCentre(centre)
	SetTextEntry("STRING")
	AddTextComponentString(text)
	DrawText(x , y)
end

-------------------------------------------------
----------------CONFIG BACK MENU-----------------
-------------------------------------------------

function BackMenuPolice()
	if backlock then
		return
	end
	backlock = true
	if menupolice.currentmenu == "main" then
		CloseMenuPolice()
	elseif menupolice.currentmenu == "Animations" or menupolice.currentmenu == "Citoyen" or menupolice.currentmenu == "Véhicule" or menupolice.currentmenu == "Amendes" then
		OpenMenuPolice(menupolice.lastmenu)
	else
		OpenMenuPolice(menupolice.lastmenu)
	end
end

-------------------------------------------------
---------------------FONCTION--------------------
-------------------------------------------------

function f(n)
return n + 0.0001
end

function LocalPed()
return GetPlayerPed(-1)
end

function try(f, catch_f)
local status, exception = pcall(f)
if not status then
catch_f(exception)
end
end
function firstToUpper(str)
    return (str:gsub("^%l", string.upper))
end

function tablelength(T)
  local count = 0
  for _ in pairs(T) do count = count + 1 end
  return count
end

function round(num, idp)
  if idp and idp>0 then
    local mult = 10^idp
    return math.floor(num * mult + 0.5) / mult
  end
  return math.floor(num + 0.5)
end

function stringstarts(String,Start)
   return string.sub(String,1,string.len(Start))==Start
end

-------------------------------------------------
----------------FONCTION OPEN--------------------
-------------------------------------------------
function OpenPoliceMenu()
	menupolice.currentmenu = "main"
	menupolice.opened = true
	menupolice.selectedbutton = 0
end

-------------------------------------------------
----------------FONCTION CLOSE-------------------
-------------------------------------------------

function CloseMenuPolice()
		menupolice.opened = false
		menupolice.menu.from = 1
		menupolice.menu.to = 10
end

-------------------------------------------------
----------------FONCTION OPEN MENU---------------
-------------------------------------------------

local backlock = false
Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)
		if (IsControlJustPressed(1,166) and menupolice.opened == true) then
				CloseMenuPolice()
		end
		if menupolice.opened then
			local ped = LocalPed()
			local menu = menupolice.menu[menupolice.currentmenu]
			drawTxt(menupolice.title,1,1,menupolice.menu.x,menupolice.menu.y,1.0, 255,255,255,255)
			drawMenuTitle(menu.title, menupolice.menu.x,menupolice.menu.y + 0.08)
			drawTxt(menupolice.selectedbutton.."/"..tablelength(menu.buttons),0,0,menupolice.menu.x + menupolice.menu.width/2 - 0.0385,menupolice.menu.y + 0.067,0.4, 255,255,255,255)
			local y = menupolice.menu.y + 0.12
			buttoncount = tablelength(menu.buttons)
			local selected = false

			for i,button in pairs(menu.buttons) do
				if i >= menupolice.menu.from and i <= menupolice.menu.to then

					if i == menupolice.selectedbutton then
						selected = true
					else
						selected = false
					end
					drawMenuButton(button,menupolice.menu.x,y,selected)
					if button.distance ~= nil then
						drawMenuRight(button.distance.."m",menupolice.menu.x,y,selected)
					end
					y = y + 0.04
					if selected and IsControlJustPressed(1,201) then
						ButtonSelectedPolice(button)
					end
				end
			end
		end
		if menupolice.opened then
			if IsControlJustPressed(1,202) then
				BackMenuPolice()
			end
			if IsControlJustReleased(1,202) then
				backlock = false
			end
			if IsControlJustPressed(1,188) then
				if menupolice.selectedbutton > 1 then
					menupolice.selectedbutton = menupolice.selectedbutton -1
					if buttoncount > 10 and menupolice.selectedbutton < menupolice.menu.from then
						menupolice.menu.from = menupolice.menu.from -1
						menupolice.menu.to = menupolice.menu.to - 1
					end
				end
			end
			if IsControlJustPressed(1,187)then
				if menupolice.selectedbutton < buttoncount then
					menupolice.selectedbutton = menupolice.selectedbutton +1
					if buttoncount > 10 and menupolice.selectedbutton > menupolice.menu.to then
						menupolice.menu.to = menupolice.menu.to + 1
						menupolice.menu.from = menupolice.menu.from + 1
					end
				end
			end
		end

	end
end)