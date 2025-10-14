local SimplePool = require(PathTo.SimplePool)

-- First we need a template or else, it will have no template
local templatePart = Instance.new("Part")
templatePart.Name = "TemplatePart"
templatePart.Parent = workspace
templatePart.Position = Vector3.new(0,5,0)
templatePart.Size = Vector3.new(1,1,1)

local Pool1 = SimplePool.new(templatePart)

-- Prewarm Example
Pool1:Prewarm(10)

-- GetObject Example (IF THERE NO OBJ STORED TO POOL1, THE POOL1 WILL TRY TO GET TEMPLATE INSTEAD)
local obj1 = Pool1:GetObject()
obj1.Name = "OBJ1"
print(obj1.Name)

-- ReturnObject Example 
Pool1:ReturnObject(obj1)

-- Events Example 
-- api : Fire(), Connect((...) -> ()), Disconnect(), other...
--- OnGetObject
Pool1.OnGetObject:Connect(function(obj1)
    print("GET: " .. obj1.Name)
end)

--- OnReturnObject
Pool1.OnReturnObject:Connect(function(obj1)
    print("RET: " .. obj1.Name)
end)

-- that all Enjoys :D
