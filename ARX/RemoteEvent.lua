local modules = {};

function modules:joinChallange()
    local args = {
        [1] = "Create",
        [2] = {
            ["CreateChallengeRoom"] = true
        }
    };
    
    game:GetService("ReplicatedStorage"):WaitForChild("Remote"):WaitForChild("Server"):WaitForChild("PlayRoom"):WaitForChild("Event"):FireServer(unpack(args));

    wait(0.5);

    local args = {
        [1] = "Start",
    }
    
    game:GetService("ReplicatedStorage"):WaitForChild("Remote"):WaitForChild("Server"):WaitForChild("PlayRoom"):WaitForChild("Event"):FireServer(unpack(args))
end

function modules:joinMap(mode, world, chapter, difficulty)
    local args = {
        [1] = "Create"
    };
    
    game:GetService("ReplicatedStorage"):WaitForChild("Remote"):WaitForChild("Server"):WaitForChild("PlayRoom"):WaitForChild("Event"):FireServer(unpack(args));

    wait(0.1);

    local args = {
        [1] = "Change-Mode",
        [2] = {
            ["Mode"] = mode;
        }
    }
    
    game:GetService("ReplicatedStorage"):WaitForChild("Remote"):WaitForChild("Server"):WaitForChild("PlayRoom"):WaitForChild("Event"):FireServer(unpack(args))

    wait(0.1);

    local args = {
        [1] = "Change-World",
        [2] = {
            ["World"] = world
        }
    }
    
    game:GetService("ReplicatedStorage"):WaitForChild("Remote"):WaitForChild("Server"):WaitForChild("PlayRoom"):WaitForChild("Event"):FireServer(unpack(args))

    wait(0.1);

    local args = {
        [1] = "Submit"
    }
    
    game:GetService("ReplicatedStorage"):WaitForChild("Remote"):WaitForChild("Server"):WaitForChild("PlayRoom"):WaitForChild("Event"):FireServer(unpack(args))

    wait(0.1);

    local args = {
        [1] = "Start",
    }
    
    game:GetService("ReplicatedStorage"):WaitForChild("Remote"):WaitForChild("Server"):WaitForChild("PlayRoom"):WaitForChild("Event"):FireServer(unpack(args))
end

return modules;