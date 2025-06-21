
task.spawn(function()
    repeat wait() until game:FindFirstChild("CoreGui")
    for _,v in pairs(game.CoreGui:GetDescendants()) do
        if v:IsA("TextLabel") or v:IsA("TextButton") then
            if string.find(v.Text, "KaterHub") then
                v.Text = string.gsub(v.Text, "KaterHub", "Lossway Hub")
            end
        end
    end
end)
