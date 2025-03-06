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
-- Создаем нового врага bat
    if swapn_bat_timer() == 0 then
        local bat = Bat()
        bat:spawn(p1)
        add(enemies_bats, bat)
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

        -- Проверяет столкновения оружие с врагами
        if p1.weapon.hit then
            if p1.weapon:isCollision(enemy) then
                sfx(0)
                enemy.hp = enemy.hp - 1
            end
        end
        
        -- Проверяет сколько хп у врага
        if enemy.hp <= 0 then
            del(enemies_bats, enemy)
            score = score + 1
        end
    end
end

-- MODE 
function update_game_over()
    camera(0, 0)
end

function draw_game_over()
    cls(1)

    print("game over", 48, 56, 8)
    print("score:" .. score, 8, 8, 8)
end

function update_game_level_1()
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
    circfill(64, 64, 64, 11)
    print("hp:" .. p1.hp, p1.x-64+8, p1.y-64+8, 7)
    print("score:" .. score, p1.x-64+8, p1.y-64+16, 7)

    p1:draw()
    
    for enemy in all(enemies_bats) do
        enemy:draw()
    end
end