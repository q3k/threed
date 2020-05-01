// ThreeD, a 3d text thingamabob for Garry's Mod
// Copyright 2010-2020 Serge 'q3k' Bazanski <q3k@q3k.org>
// This work is free. You can redistribute it and/or modify it under the
// terms of the Do What The Fuck You Want To Public License, Version 2,
// as published by Sam Hocevar. See http://www.wtfpl.net/ for more details.

Msg("[ThreeD] Bootstrapping...\n")
AddCSLuaFile("autorun/client/cl_bootstrap.lua")
include("threed/sv_main.lua")
