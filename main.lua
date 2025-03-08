--[[
    -- 4 марта 2025
    -- Pururun
    -- version 0.6
--]]

function _init()
    cartdata("pur_pixelpurge_0_5") --id

    buls = {}
    bul = {}
    bul_direc = "right"
    time_shoot = 30

    money_player = dget(0)


    palt(0, false)
    palt(12, true)

    mode = "main_menu"

    score = 0

    falg = false

    characters = {
        antonio = Antonio(),
        imelda = Imelda()
    }

    -- Подключаем первого игрока
    p1 = characters.imelda

    -- добавить пулю
    -- add(buls, p1.weapon)

    init_bat()
    -- t - просто считает кадры
    t = 0
end

function _update()
    if mode == "main_menu" then
        update_main_menu()
    elseif mode == "level_1" then
        update_game_level_1()
    elseif mode == "over" then
        update_game_over()
    end
end

function _draw()
    if mode == "main_menu" then
        draw_main_menu()
    elseif mode == "level_1" then
        draw_game_level_1()
    elseif mode == "over" then
        draw_game_over()
    end
end
