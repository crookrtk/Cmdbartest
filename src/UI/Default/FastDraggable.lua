
local UserInputService = game:FindService("UserInputService")

local hbAdmin = script:FindFirstAncestor("HBAdmin")
local Maid = require(hbAdmin.Util.Maid)
local Loading = require(hbAdmin.Loading.Maid)
local LoadingMaid = Loading:GetMaid()

local function FastDraggable(gui, handle, lerp)

    handle = handle or gui

    local dragging
    local dragInput
    local dragStart
    local startPos
    local maid
    local mouseDifference

    local function update(input)
        local delta = input.Position - dragStart
        gui.Position = gui.Position:Lerp( UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y), lerp)
    end

    local function updateMouse()
        local p = UserInputService:GetMouseLocation()
        local delta = (Vector3.new(p.X, p.Y, 0) + mouseDifference) - dragStart
        gui.Position = gui.Position:Lerp( UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y), lerp)
    end

    LoadingMaid:GiveTask(
    handle.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            startPos = gui.Position
            maid = Maid.new()
            maid:GiveTask(game.RunService.RenderStepped:Connect(updateMouse))
            input.Changed:Connect(function()
                if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch and input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                    maid:Destroy()
                end
            end)
        end
    end)
    )

    LoadingMaid:GiveTask(
    handle.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
            dragInput = input
        end
    end)
    )

    LoadingMaid:GiveTask(
    UserInputService.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
            local location = UserInputService:GetMouseLocation()
            mouseDifference = input.Position - Vector3.new(location.X, location.Y, 0)
            if input == dragInput and dragging then
                update(input)
            end
        end
    end)
    )

end


return FastDraggable