function love.conf(t)
    t.console = true
    t.window.title = "Demon Slayer"

    -- Using 1080p (for now)
    t.window.width = 1920   
    t.window.height = 1080

    -- window display
    t.window.display = 1
    t.window.fullscreen = false
    t.window.borderless = false


    t.window.title = "Resizable Window"
    t.window.resizable = true
end