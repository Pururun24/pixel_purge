local lemit_bat = 20 -- лемит

-- Вспомогательные функции

-- Управление для первого игрока
-- Надо подумать как улучить эту функцию
function control_player(player, player_id, btn_0, btn_1, btn_2, btn_3)
    if btn(btn_0, player_id) then
        player.x = player.x - player.spd
        player.anim = "run"
        player.flip_x = true
    end
    if btn(btn_1, player_id) then
        player.x = player.x + player.spd
        player.anim = "run"
        player.flip_x = false
    end
    if btn(btn_2, player_id) then
        player.y = player.y - player.spd
        player.anim = "run"
    end
    if btn(btn_3, player_id) then
        player.y = player.y + player.spd
        player.anim = "run"
    end
end

-- Проверяет нажата ли кнопка
function isButtonNotPressed(btn_0, btn_1, btn_2, btn_3)
    if not btn(btn_0) and not btn(btn_1) and not btn(btn_2) and not btn(btn_3) then
        return true
    end
end

-- Функция таймера
function counter(timer)
    local i = timer

    return function()
        if i < 0 then
            i = timer
        end

        i = i - 1

        return i
    end
end

-- Функция столкновения
function isCollision(a, b, a_w, a_h, b_w, b_h)
    local a_w = a_w or 7
    local a_h = a_h or 7
    local b_w = b_w or 7
    local b_h = b_h or 7

    local a_left = a.x
    local a_right = a.x + a_w
    local a_top = a.y
    local a_bottom = a.y + a_h

    local b_left = b.x
    local b_right = b.x + b_w
    local b_top = b.y
    local b_bottom = b.y + b_h

    if a_left > b_right then return false end
    if a_top > b_bottom then return false end
    if a_right < b_left then return false end
    if a_bottom < b_top then return false end

    return true
end

-- Функция ограничивает карту
function restrictToArena()
    if p1.x <= -128 then
        p1.x = -128
    elseif p1.x >= 128 then
        p1.x = 128
    end

    if p1.y <= -128 then
        p1.y = -128
    elseif p1.y >= 128 then
        p1.y = 128
    end

end

-- Некоторые удобные функции
function init_bat()
    -- Берем врага "bat"
    enemies_bats = {}
    local bat = Bat()
    bat:spawn(p1)
    add(enemies_bats, bat)
    swapn_bat_timer = counter(30)
end

function update_bat()
-- Создаем нового врага bat если не привышен лемит
    if #enemies_bats < lemit_bat then
        if swapn_bat_timer() == 0 then
            local bat = Bat()
            bat:spawn(p1)
            add(enemies_bats, bat)
        end
    end

    -- Обновляем каждого врага
    for enemy in all(enemies_bats) do
        enemy:update()

        -- Сразу проверяем столкновения с игроком
        if p1:isCollision(enemy) then
            if p1:damageColdown() == 0 then
                p1.hp = p1.hp - enemy.damage
            end
        end

        if p1.weapon.name == "whip" then
            -- Проверяет столкновения оружие с врагами
            if p1.weapon.hit then
                if p1.weapon:isCollision(enemy) then
                    sfx(0)
                    enemy.hp = enemy.hp - 1
                end
            end
        end
        
        -- Проверяет сколько хп у врага
        if enemy.hp <= 0 then
            del(enemies_bats, enemy)
            money_player  = money_player  + 1
        end
    end

    -- Столковения пули с врагом
    if p1.weapon.name == "magic wand" then
        time_shoot = time_shoot - 1

        if time_shoot == 0 then
            time_shoot = 0
        end
        -- Направления выстрела
        if btnp(0) then
            bul_direc = "left"
        elseif btnp(1) then
            bul_direc = "right"
        elseif btnp(2) then
            bul_direc = "up"
        elseif btnp(3) then
            bul_direc = "down"
        end

        -- Создаем кнопку с направлением
        if time_shoot <= 0 then
            bul = Magic_wand()
            bul:spawn(p1)

            if bul_direc == "left" then
                bul.shoot_direction = "left"
            elseif bul_direc == "right" then
                bul.shoot_direction = "right"
            elseif bul_direc == "up" then
                bul.shoot_direction = "up"
            elseif bul_direc == "down" then
                bul.shoot_direction = "down"
            end

            add(buls, bul)
            time_shoot = 30
        end

        -- Перемещаем пули
        for bul in all(buls) do
            if bul.shoot_direction == "left" then
                bul.x = bul.x - bul.spd_x
            end

            if bul.shoot_direction == "right" then
                bul.x = bul.x + bul.spd_x
            end

            if bul.shoot_direction == "up" then
                bul.y = bul.y - bul.spd_y
            end

            if bul.shoot_direction == "down" then
                bul.y = bul.y + bul.spd_y
            end
        end

        for bul in all(buls) do
            for enemy in all(enemies_bats) do
                if bul:isCollision(enemy) then
                    sfx(0)
                    enemy.hp = enemy.hp - 1
                    del(buls, bul)
                end
            end
        end
    end

    -- Столкновения bat с bat
    for key1, bat1 in pairs(enemies_bats) do
        for key2, bat2 in pairs(enemies_bats) do
            if key1 < key2 then
                if bat1:isCollision(bat2) then
                    if bat1.x < bat2.x then
                        bat1.x = bat1.x - 1
                    end
                    if bat1.x > bat2.x then
                        bat1.x = bat1.x + 1
                    end
                    if bat1.y < bat2.y then
                        bat1.y = bat1.y - 1
                    end
                    if bat1.y > bat2.y then
                        bat1.y = bat1.y + 1
                    end
                end
            end
        end
    end
end

-- MODE 
function update_game_over()
    camera(0, 0)
    save_money_player() -- Сохраняем деньги игрока

    if btnp(4) or btnp(5) then
        mode = "main_menu"
    end
end

function draw_game_over()
    cls(1)

    print("game over", 48, 56, 8)
    print("your earned money:" .. money_player, 24, 72, 8)
    print("click on the button to exit", 8, 112, 8)
end

function update_game_level_1()
    restrictToArena() -- Ограничиваем карту
    control_player(p1, 0, 0, 1, 2, 3)

    update_bat()

    t = t + 1
    camera(p1.x-64, p1.y-64)
end

function draw_game_level_1()
    if p1.hp <= 0 then
        mode = "over"
    end
    cls(3)
    circfill(0, 0, 64, 11)
    print("hp:" .. p1.hp, p1.x-64+8, p1.y-64+8, 7)
    print("money:" .. money_player, p1.x-64+8, p1.y-64+16, 7)

    --test--
    print("x:" .. p1.x, p1.x-64+8, p1.y-64+24, 7)
    print("y:" .. p1.y, p1.x-64+8, p1.y-64+32, 7)
    print("bats:" .. #enemies_bats, p1.x-64+8, p1.y-64+40, 7)

    -- Рисуем игрока
    p1:draw()


    if p1.weapon.name == "magic wand" then
        if #buls ~= 0 then
            for bul in all(buls) do
                spr(bul.frame_hit[1], bul.x, bul.y)
            end
        end
    end
    print(#buls, 32, 32, 6)
    --print(flag, 32, 32, 6)
    
    for enemy in all(enemies_bats) do
        enemy:draw()
    end
end

function save_money_player()
    dset(0, money_player)
end