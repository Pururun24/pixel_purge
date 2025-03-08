local choice_mode = 1
local menu_start = 0
local menu_option = 0
local menu_power_up = 0
local menu_color_start = 6
local menu_color_option = 6
local menu_color_power_up = 6

-- Главное меню
function update_main_menu()
    if btnp(2) then
        choice_mode = choice_mode - 1

        -- Проверяем не выходим за пределы меню
        if choice_mode < 1 then
            choice_mode = 1
        end
    end
    if btnp(3) then
        choice_mode = choice_mode + 1

        if choice_mode > 3 then
            choice_mode = 3
        end
    end

    -- Переходим в режим от нажатие кнопки
    if btnp(4) then
        if choice_mode == 1 then
            mode = "level_1"
        elseif choice_mode == 2 then
            mode = "option"
        elseif choice_mode == 3 then
            mode = "power_up"
        end
    end

    -- Проверяем какой режим выбран
    if choice_mode == 1 then
        menu_color_start = 8
        menu_color_option = 6
        menu_color_power_up = 6
    elseif choice_mode == 2 then
        menu_color_start = 6
        menu_color_option = 8
        menu_color_power_up = 6
    elseif choice_mode == 3 then
        menu_color_start = 6
        menu_color_option = 6
        menu_color_power_up = 8
    end
end

function draw_main_menu()
    cls(1)
    print("you money:" .. money_player, 36, 32, 6)
    print("pixel purge", 40, 8, 6)
    print("version:0.5", 72, 120, 6)
    print("start game", 42, 56, menu_color_start)
    print("option", 50, 96, menu_color_option)
    print("power_up", 8, 96, menu_color_power_up)
end