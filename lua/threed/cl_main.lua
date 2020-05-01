// ThreeD, a 3d text thingamabob for Garry's Mod
// Copyright 2010-2020 Serge 'q3k' Bazanski <q3k@q3k.org>
// This work is free. You can redistribute it and/or modify it under the
// terms of the Do What The Fuck You Want To Public License, Version 2,
// as published by Sam Hocevar. See http://www.wtfpl.net/ for more details.

function _R.bf_read:ReadColor()
    return Color(self:ReadChar() + 128, self:ReadChar() + 128, self:ReadChar() + 128, self:ReadChar() + 128);
end

threed = {}
threed.Active = false
threed.Stored = {}
threed.Settings = {}

function threed.GetAlphaForDistance(Distance)
    return math.Clamp(255 - (255 / threed.Settings.FadeDistance) * Distance, 0, 255)
end

function threed.PaintHook()
    if not threed.Active then return end
    for _, Item in pairs(threed.Stored) do
        local Text = Item.Text
        local Position = Item.Position
        local Angles = Item.Angles
        local Size = Item.Size
        
        local Alpha = threed.GetAlphaForDistance(LocalPlayer():EyePos():Distance(Position))
        local Color = Color(threed.Settings.Color.r, threed.Settings.Color.g, threed.Settings.Color.b, Alpha)
        
        cam.Start3D2D(Position, Angles, Size / 100)
            draw.DrawText(Text, "ThreeD", 0, 0, Color, TEXT_ALIGN_CENTER)
        cam.End3D2D()
    end
end
hook.Add("PostDrawOpaqueRenderables", "threed.PaintHook", threed.PaintHook)

function threed.AddText(Text, Position, Angles, Size)
    local Item = {}
    
    Item.Text = Text
    Item.Position = Position
    Item.Angles = Angles
    Item.Size = Size
    
    table.insert(threed.Stored, Item)
end

function threed.ReceiveInitialMesage(um)
    threed.Settings.Font = um:ReadString()
    threed.Settings.AA = um:ReadBool()
    threed.Settings.Color = um:ReadColor()
    threed.Settings.Weight = um:ReadShort()
    threed.Settings.FadeDistance = um:ReadLong()
    
    surface.CreateFont(threed.Settings.Font, ScreenScale(800), threed.Settings.Weight, threed.Settings.AA, false, "ThreeD")
    
    Msg("[ThreeD] Starting...\n")
    
    threed.Active = true
end
usermessage.Hook("threed.InitialMessage", threed.ReceiveInitialMesage)

function threed.ReceiveItemData(um)
    local Text = um:ReadString()
    local Position = um:ReadVector()
    local Angles = um:ReadAngle()
    local Size = um:ReadShort()
    
    threed.AddText(Text, Position, Angles, Size)
end
usermessage.Hook("threed.ItemData", threed.ReceiveItemData)

function threed.ReceiveRemoveAll(um)
    threed.Stored = {}
end
usermessage.Hook("threed.RemoveAll", threed.ReceiveRemoveAll)
