
-- use functions and tables to create enemies
-- this function creates and returns the enemy


function Enemy()
    return{
        level = 1,
        radius = 20,
        x = -10,
        y = -50,

        move = function (self, Player_x, Player_y)
            if Player_x - self.x > 0 then
                self.x = self.x + self.level 
            elseif Player_x -self.x < 0 then
                self.x = self.x - self.level 
            end

            if Player_y - self.y > 0 then
                self.y = self.y + self.level 
            elseif Player_y -self.y < 0 then
                self.y = self.y - self.level 
            end
        end,

        draw = function (self)
            love.graphics.setColor(1,2,3)
            love.graphics.circle("fill", self.x, self.y, self.radius)
        end,

        love.graphics.setColor("white")
    }
end

return Enemy