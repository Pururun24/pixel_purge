-- Создаем объект персонажа
function Character()
    local player = {}

    player.hp = 20
    player.x = 0
    player.y = 0
    player.spd = 2
    player.weapon = {}
    player.flip_x = false
    player.idle = {}
    player.run = {}
    player.anim = "idle"
    player.damageColdown = counter()

    -- Столкновения игрока с объектом
    player.isCollision = function(self, b)
        return isCollision(self, b)
    end

    return player
end

-- Наследуем объект персонаж, для создание объекта Антонио
function Antonio()
    local antonio = Character()

    -- Анимации
    antonio.idle = {1, 2}
    antonio.run = {3, 4}

    -- Настраиваем задержку получение урона для Антонио
    antonio.damageColdown = counter(5)

    -- Анимация ожидание
    antonio.anim_idle = function(self, delay, frame_delay)
        local i = 1

        if sin(t/delay)<frame_delay then
            spr(self.idle[i+1], self.x, self.y, 1, 1, self.flip_x)
        else
            spr(self.idle[i], self.x, self.y, 1, 1, self.flip_x)
        end
    end

    -- Анимация движения
    antonio.anim_run = function(self, delay, frame_delay)
        local i = 1

        if sin(t/delay)<frame_delay then
            spr(self.run[i+1], self.x, self.y, 1, 1, self.flip_x)
        else
            spr(self.run[i], self.x, self.y, 1, 1, self.flip_x)
        end
    end

    -- Даем оружие, кнут
    antonio.weapon = Whip()

    -- Анимацию битвы и скорость удара
    antonio.anim_player_battle = function(self)
        self.weapon:anim_hit(self, 30, 0.99) -- поменять на скорость персонажа
    end

    -- Рисуем персонажа
    antonio.draw = function(self)
        -- Движение
        if self.anim == "idle" then
            self:anim_idle(30, 0)
        elseif self.anim == "run" then
            self:anim_run(30, 0)

            if isButtonNotPressed() then
                self.anim = "idle"
            end
        end

        -- Битва
        self:anim_player_battle()

        -- Анимация битвы
        local i = 1
        if self.weapon.hit then
            spr(self.weapon.frame_hit[i], self.weapon.x, self.weapon.y, 1, 1, self.flip_x)
        else
            spr(self.weapon.frame_hit[i+1], self.weapon.x, self.weapon.y, 1, 1, self.flip_x)
        end
    end

    return antonio
end

-- Имельда
function Imelda()
    local imelda = Character()

    imelda.hp = 15

    -- Анимации
    imelda.idle = {16, 17}
    imelda.run = {18, 19}

    -- Скорость получения урона
    imelda.damageColdown = counter(5)

    imelda.anim_idle = function(self, delay, frame_delay)
        local i = 1

        if sin(t/delay)<frame_delay then
            spr(self.idle[i+1], self.x, self.y, 1, 1, self.flip_x)
        else
            spr(self.idle[i], self.x, self.y, 1, 1, self.flip_x)
        end
    end

    imelda.anim_run = function(self, delay, frame_delay)
        local i = 1

        if sin(t/delay)<frame_delay then
            spr(self.run[i+1], self.x, self.y, 1, 1, self.flip_x)
        else
            spr(self.run[i], self.x, self.y, 1, 1, self.flip_x)
        end
    end

    -- Даем оружие, жезл
    imelda.weapon = Magic_wand()

    -- imelda.anim_player_battle = function(self)
    --     self.weapon:anim_hit() -- поменять на скорость персонажа
    -- end

    -- Рисуем
    imelda.draw = function(self)
        if self.anim == "idle" then
            self:anim_idle(30, 0)
        elseif self.anim == "run" then
            self:anim_run(30, 0)

            if isButtonNotPressed() then
                self.anim = "idle"
            end
        end
    end

    return imelda
end