# SimplePool
A simple ModuleScript, easy-to-use, statically typed, object pool for reusing Roblox Instances, reducing instantiation overhead.

Licesnse Under : MIT Licesnse

Copyright(c) 2025 Mawin CK
---
## API :
How to Create SimplePool :
```luau
local SimplePool = require(PathTo.SimplePool)
local template : Insance = YourTemplateInstance

local Pool = SimplePool.new()
```
How to Prewarm(Clonings Template Instance) :
```luau
Pool:Prewarm(10)
```
