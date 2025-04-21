function ESP:Add(obj, options)
    if not obj.Parent and not options.RenderInNil then
        return warn(obj, "has no parent")
    end

    local box = setmetatable({
        Name = options.Name or obj.Name,
        Type = "Box",
        Color = options.Color,
        Size = options.Size or self.BoxSize,
        Object = obj,
        Player = options.Player or plrs:GetPlayerFromCharacter(obj),
        PrimaryPart = options.PrimaryPart or obj.ClassName == "Model" and (obj.PrimaryPart or obj:FindFirstChild("HumanoidRootPart") or obj:FindFirstChildWhichIsA("BasePart")) or obj:IsA("BasePart") and obj,
        Components = {},
        IsEnabled = options.IsEnabled,
        Temporary = options.Temporary,
        ColorDynamic = options.ColorDynamic,
        RenderInNil = options.RenderInNil
    }, boxBase)

    -- Menghapus ESP jika model dihapus atau mati
    if self:GetBox(obj) then
        self:GetBox(obj):Remove()
    end

    -- Membuat komponen box
    box.Components["Quad"] = Draw("Quad", {
        Thickness = self.Thickness,
        Color = options.Color,
        Transparency = 1,
        Filled = false,
        Visible = self.Enabled and self.Boxes
    })
    box.Components["Name"] = Draw("Text", {
        Text = box.Name,
        Color = box.Color,
        Center = true,
        Outline = true,
        Size = 19,
        Visible = self.Enabled and self.Names
    })
    box.Components["Distance"] = Draw("Text", {
        Color = box.Color,
        Center = true,
        Outline = true,
        Size = 19,
        Visible = self.Enabled and self.Names
    })
    
    -- Penanganan Tracer jika diaktifkan
    box.Components["Tracer"] = Draw("Line", {
        Thickness = ESP.Thickness,
        Color = box.Color,
        Transparency = 1,
        Visible = self.Enabled and self.Tracers
    })
    
    self.Objects[obj] = box
    
    -- Menambahkan pengecekan ketika objek dihapus
    obj.AncestryChanged:Connect(function(_, parent)
        if parent == nil and ESP.AutoRemove ~= false then
            box:Remove()  -- Menghapus ESP jika objek dihapus
        end
    end)

    -- Menambahkan pengecekan kematian objek dan menghapus ESP ketika objek mati
    local hum = obj:FindFirstChildOfClass("Humanoid")
    if hum then
        hum.Died:Connect(function()
            -- Hapus ESP saat objek mati
            box:Remove()  -- Menghapus ESP ketika karakter atau objek mati
        end)
    end

    return box  -- Menambahkan return untuk mengembalikan objek ESP yang telah ditambahkan
end

return ESP
