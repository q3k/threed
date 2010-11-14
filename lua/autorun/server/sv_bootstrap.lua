// ThreeD, a 3d text thingamabob for Garry's Mod
// By Sergiusz Bazañski, a.k.a. q3k.
// This code is released under the do-whatever-you-want-but-don't-be-a-douche license.
// www.q3k.org, 2010

Msg("[ThreeD] Bootstrapping...\n")
AddCSLuaFile("autorun/client/cl_bootstrap.lua")
include("threed/sv_main.lua")