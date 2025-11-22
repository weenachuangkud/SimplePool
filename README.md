# SimplePool (deprecated)
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
How to Get And Return an Object 
(Notices: if you use `Pool:GetObject()` and `Pool.Pool` is Empty, it will Clone the Template and use the Template instead
```luau
local Obj = Pool:GetObject()
-- do something
Pool:ReturnObject(Obj)
```
How to Clear?
```luau
Pool:Clear()
```
How to Use Signals?
```luau
Pool.OnGetObject:Connect(function(obj)
    print(obj.Name .. " : GET")
end

Pool.OnReturnObject:Connect(function(obj)
    print(obj.Name .. " : RET")
end
```
