// ThreeD, a 3d text thingamabob for Garry's Mod
// Copyright 2010-2020 Serge 'q3k' Bazanski <q3k@q3k.org>
// This work is free. You can redistribute it and/or modify it under the
// terms of the Do What The Fuck You Want To Public License, Version 2,
// as published by Sam Hocevar. See http://www.wtfpl.net/ for more details.

TOOL.Category = "Render"
TOOL.Name = "ThreeD Text"
TOOL.Command = nil
TOOL.ConfigName = ""

TOOL.ClientConVar["text"] = "Some Friendly Text"
TOOL.ClientConVar["size"] = "10"

if CLIENT then
    language.Add("tool.threed.name", "ThreeD Text Tool")
    language.Add("tool.threed.desc", "Places a 3D text at the hit position.")
    language.Add("tool.threed.left", "Place text")
    language.Add("tool.threed.right", "Remove text near hit position")
    TOOL.Information = { "left", "right" }
end

function TOOL:LeftClick(Trace)
    if CLIENT then return end
    
    local Text = self:GetClientInfo("text")
    local Size = self:GetClientNumber("size")
    
    local Position = Trace.HitPos + (Trace.HitNormal * 2)
    local Angles = Trace.HitNormal:Angle()
    
    Angles:RotateAroundAxis(Angles:Forward(), 90);
    Angles:RotateAroundAxis(Angles:Right(), 270);
    
    threed.AddText(Text, Position, Angles, Size)
    
    return true
end

function TOOL:RightClick(Trace)
    if CLIENT then return end
    
    local Position = Trace.HitPos
    
    for Index, Item in pairs(threed.Stored) do
        if Item.Position:Distance(Position) < 200 then
            threed.RemoveText(Index)
            return true
        end
    end
    
    return false
end

function TOOL.BuildCPanel(Panel)
    Panel:AddControl("Header", {Text = "ThreeD Text", Description = "Allows you to place 3D text in-game"})
    
    Panel:AddControl("TextBox", {
        Label = "Text",
        Command = "threed_text",
        MaxLength = "200"
    })
    
    Panel:AddControl("Slider", {
        Label = "Text Size",
        Command = "threed_size",
        Type = "Float",
        Min = 1,
        Max = 50
    })
end
