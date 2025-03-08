-- Создаем объект для врагов
-- Спамить врагов за камерой
function Enemy()
    local enemy = {}

    enemy.hp = 1
    enemy.damage = 1
    enemy.x = 0
    enemy.y = 0
    enemy.spd = 0.5
    enemy.anim = "idle"
    enemy.flip_x = false

    -- Столкновения врага с объектом
    enemy.isCollision = function(self, b)
        return isCollision(self, b)
    end

    -- Спавн врагов от игрока
    enemy.spawn = function(self, player)
        -- Позиция
        local pos = {
            "left", "right", "top", "bottom", 
            "left_top", "left_bottom",
            "right_top", "right_bottom"}

        local rand_pos = rnd(pos)

        if rand_pos == "left" then
            self.x = player.x - 72
            self.y = player.y
        elseif rand_pos == "right" then
            self.x = player.x + 72
            self.y = player.y
        elseif rand_pos == "top" then
            self.x = player.x
            self.y = player.y - 72
        elseif rand_pos == "bottom" then
            self.x = player.x
            self.y = player.y + 72
        elseif rand_pos == "left_top" then
            self.x = player.x - 72
            self.y = player.y - 72
        elseif rand_pos == "left_bottom" then
            self.x = player.x - 72
            self.y = player.y + 72
        elseif rand_pos == "right_top" then
            self.x = player.x + 72
            self.y = player.y - 72
        elseif rand_pos == "right_bottom" then
            self.x = player.x + 72
            self.y = player.y + 72
        end
    end

    return enemy
end

function Bat()
    local bat = Enemy()

    bat.anim = "flight"

    bat.flight = {64, 65}

    bat.spawn_timer = counter(10)

    -- Анимация полета
    bat.anim_flight = function(self, delay, frame_delay)
        local i = 1

        if sin(t/delay)<frame_delay then
            spr(self.flight[i+1], self.x, self.y, 1, 1, self.flip_x)
        else
            spr(self.flight[i], self.x, self.y, 1, 1, self.flip_x)
        end
    end

    -- Двигаем bat к игроку
    bat.movement = function(self, player)
        if self.x < player.x then
            self.x = self.x + self.spd
            self.flip_x = false
        elseif self.x > player.x then
            self.x = self.x - self.spd
            self.flip_x = true
        end

        if self.y < player.y then
            self.y = self.y + self.spd
        elseif self.y > player.y then
            self.y = self.y - self.spd
        end
    end

    -- Основные функции для перемешение мыши и для каждого объекта
    bat.update = function(self)
        self:movement(p1)
    end

    bat.draw = function(self)
        if self.anim == "flight" then
            self:anim_flight(30, 0)
        end
    end

    return bat
end