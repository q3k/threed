// ThreeD, a 3d text thingamabob for Garry's Mod
// By Sergiusz Bazañski, a.k.a. q3k.
// This code is released under the do-whatever-you-want-but-don't-be-a-douche license.
// www.q3k.org, 2010

require('glon')

AddCSLuaFile("threed/cl_main.lua")

threed = {}
threed.Stored = {}

include('threed/sv_config.lua')

function umsg.Color(Color)
	umsg.Char(Color.r - 128)
	umsg.Char(Color.g - 128)
	umsg.Char(Color.b - 128)
	umsg.Char(Color.a - 128)
end

function threed.InitialSpawnHook(Player)
	umsg.Start("threed.InitialMessage")
		umsg.String(threed.Config.FontFamily)
		umsg.Bool(threed.Config.AntiAliased)
		umsg.Color(threed.Config.Color)
		umsg.Short(threed.Config.Weight)
		umsg.Long(threed.Config.FadeDistance)
	umsg.End()
	
	for _, Item in pairs(threed.Stored) do
		threed.SendItemData(Item, Player)
	end
end
hook.Add("PlayerInitialSpawn", "threed.InitialSpawn", threed.InitialSpawnHook)

function threed.SendItemData(Item, Player)
	umsg.Start("threed.ItemData", Player)
		umsg.String(Item.Text)
		umsg.Vector(Item.Position)
		umsg.Angle(Item.Angles)
		umsg.Short(Item.Size)
	umsg.End()
end

function threed.AddText(Text, Position, Angles, Size)
	local Table = {}
	
	Table.Text = Text
	Table.Position = Position
	Table.Angles = Angles
	Table.Size = Size
	
	table.insert(threed.Stored, Table)
	threed.SendItemData(Table)
	threed.SaveData()
end

function threed.RemoveText(Index)
	table.remove(threed.Stored, Index)
	
	//hack!
	
	umsg.Start("threed.RemoveAll")
	umsg.End()
	
	for _, Item in pairs(threed.Stored) do
		threed.SendItemData(Item)
	end
end

function threed.SaveData()
	local MapName = game.GetMap()
	local Data = glon.encode(threed.Stored)
	
	file.Write("ThreeD/" .. MapName .. ".txt", Data)
end

function threed.InitializeHook()
	local MapName = game.GetMap()
	
	if file.Exists("ThreeD/" .. MapName .. ".txt") then
		local Data = file.Read("ThreeD/" .. MapName .. ".txt")
		threed.Stored = glon.decode(Data)
	end
end
hook.Add("Initialize", "threed.Initialize", threed.InitializeHook)