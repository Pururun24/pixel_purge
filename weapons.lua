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

    whip.name = "whip"

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

-- Волшебный жезл
function Magic_wand()
    local mw = Weapon()

    mw.name = "magic wand"

    mw.spd_x = 1
    mw.spd_y = 1
    --mw.direction = "right"
    mw.shoot_direction = "right"

    mw.frame_hit = {20}

    -- Время для выстрела
    mw.timer_shoot = counter(30)

    -- Функция инициализация
    mw.spawn = function(self, player)
        self.x = player.x
        self.y = player.y
    end

    mw.shoot = function(self)
        -- local direction = {"left", "right", "up", "down"}

        -- self.x = self.x + self.spd_x
        -- self.y = self.y + self.spd_y
        if btnp(0) then
            return "left"
        elseif btnp(1) then
            return "right"
        elseif btnp(2) then
            return "up"
        elseif btnp(3) then
            return "down"
        end

        -- if bul.x > enemy.x then
        --     self.x = self.x - self.spd
        -- elseif bul.x < enemy.x then
        --     self.x = self.x + self.spd
        -- elseif bul.y > enemy.y then
        --     self.y = self.y - self.spd
        -- elseif bul.y < enemy.y then
        --     self.y = self.y + self.spd
        -- end
    end

    -- mw.update = function(self)
    --     if self:timer_shoot() == 0 then
    --         add(buls, {1, 2})
    --     end
    -- end

    return mw
end