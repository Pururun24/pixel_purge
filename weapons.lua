-- Класс для создания оружий
function Weapon()
    weapon = {}

    weapon.x = 0
    weapon.y = 0
    weapon.frame_hit = {}
    weapon.hit = false

    weapon.isCollision = function(self, b)
        return isCollision(self, b)
    end

    return weapon
end

-- Хлыст
function Whip()
    local whip = Weapon()

    whip.frame_hit = {5, 6}

    whip.anim_hit = function(self, player, delay, frame_delay)
        -- Зазеркалить кнут, если персонаж поворачиваеться
        if player.flip_x then
            self.x = player.x - 8
        else
            self.x = player.x + 8
        end

        self.y = player.y

        if sin(t/delay)<frame_delay then
            self.hit = false
            --spr(self.weapon[i+1], self.x, self.y, 1, 1, player.flip_x)
        else
            self.hit = true
            --spr(self.weapon[i], self.x, self.y, 1, 1, player.flip_x)
        end
    end

    return whip
end