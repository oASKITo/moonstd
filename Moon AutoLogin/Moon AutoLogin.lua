script_name = 'Moon AutoLogin' -- Название скрипта
script_prefix = '{068aff}[Moon AutoLogin] ' -- Префикс скрипта
script_author = 'ASKIT' -- Автор скрипта
script_version = '05.10.21' -- Версия скрипта
script_version_number = 2 -- Номер версии скрипта
script_site = 'vk.com/moonstd' -- Сайт

require "lib.moonloader"
local sampev = require('lib.samp.events')
local imgui = require 'imgui'
local encoding = require 'encoding'
local inicfg = require 'inicfg'
local cfg = inicfg.load({
    settings =
    {
        active = false,
        pass1 = 32,
        pass2 = 32
    }
})

encoding.default = 'cp1251'
local u8 = encoding.UTF8

---------------------
local mainWindowState = imgui.ImBool(false)

local active = imgui.ImBool(cfg.settings.active)
local pass1 = imgui.ImBuffer(cfg.settings.pass1)
local pass2 = imgui.ImBuffer(cfg.settings.pass2)
---------------------


function main()
    if not isSampLoaded() or not isSampfuncsLoaded() then return end
    while not isSampAvailable() do wait(100) end

    -- Обновление
        if checkUpdates('https://raw.githubusercontent.com/oASKITo/moonstd/main/Moon%20AutoLogin/version.json?token=AMULBFICW2UNYZJW2WZZ6F3BLWFNU') then update('https://raw.githubusercontent.com/oASKITo/moonstd/main/Moon%20AutoLogin/Moon%20AutoLogin.lua?token=AMULBFK6W3TNGXS5IKK3VT3BLWGLO') end

    -- Сообщения
        print('{068aff}-------------------------------------------------')
        print('{068aff}| {ffffff}Скрипт успешно загружен. Меню скрипта: {ffd700}/mal')
        print('{068aff}| {ffffff}Разработчик скрипта: {ffd700}vk.com/moonstd')
        print('{068aff}-------------------------------------------------')

    -- Команды
        sampRegisterChatCommand("mal", cmd_mal)

    -- Функции
        Process()

end


-- Основная команда
function cmd_mal(arg)

    if arg == '' then
        mainWindowState.v = not mainWindowState.v
        imgui.Process = mainWindowState.v

    elseif arg == 'reload' then
        scriptReload()
    end

end


-- Отрисовка ImGui
function imgui.OnDrawFrame()

    if mainWindowState.v then
        local resX, resY = getScreenResolution()
        imgui.SetNextWindowSize(imgui.ImVec2(300, 150), 2)
        imgui.SetNextWindowPos(imgui.ImVec2(resX/2, resY/2), 2, imgui.ImVec2(0.5, 0.5))
        imgui.Begin(script_name..' '..script_version, mainWindowState, imgui.WindowFlags.NoResize)

            if imgui.Checkbox(u8'Авто-ввод паролей', active) then
                cfg.settings.active = active.v
                inicfg.save(cfg)
                Process()
            end
            imgui.Spacing()
            imgui.Spacing()
            imgui.PushItemWidth(150)
            if imgui.InputText(u8' Пароль от аккаунта', pass1, imgui.InputTextFlags.Password) then
                cfg.settings.pass1 = pass1.v
                inicfg.save(cfg)
            end
            imgui.PushItemWidth(150)
            if imgui.InputText(u8' Пароль от админки', pass2, imgui.InputTextFlags.Password) then
                cfg.settings.pass2 = pass2.v
                inicfg.save(cfg)
            end
            imgui.Spacing()
            imgui.Spacing()
            imgui.SetCursorPosX((imgui.GetWindowWidth() - imgui.CalcTextSize(u8"Связаться с Автором").x) / 2)
            if imgui.Button(u8'Связаться с Автором') then os.execute('explorer "https://vk.com/askit.himself"') end

        imgui.End()
        imgui.Process = mainWindowState.v
    end

end


-- Процесс ввода паролей
function Process()

    if cfg.settings.active then
        lua_thread.create(function()
            while true do wait(0)
                if cfg.settings.active then
                    if sampIsDialogActive() ~= 0 then
                        if dialog == '1' then
                            sampSetCurrentDialogEditboxText(cfg.settings.pass1)
                            sampCloseCurrentDialogWithButton(1)
                            dialog = '0'
                        elseif dialog == '2' then
                            sampSetCurrentDialogEditboxText(cfg.settings.pass2)
                            sampCloseCurrentDialogWithButton(1)
                            dialog = '0'

                        end
                    end

                end
            end
        end)
   end

end


-- Проверка диалога
function sampev.onShowDialog(id, style, title, button1, button2, text)

    if title == '{B789CF}Авторизация' or title == 'Авторизация' then
        dialog = '1'
    elseif text == '{FFFFFF}Введите пароль администратора:' then
        dialog = '2'

    end

end


-- Сохранение конфига
function saveData()
    inicfg.save({
        settings = {
        active = data.settings.active,
        pass1 = data.settings.pass1,
        pass2 = data.settings.pass1
        }
    }, getWorkingDirectory() .. "\\moonstd\\Moon AutoLogin.ini")
end


-- Проверка обновления
function checkUpdates(json)
  local fpath = os.tmpname()
  if doesFileExist(fpath) then os.remove(fpath) end
  downloadUrlToFile(json, fpath, function(_, status, _, _)
    if status == 58 then
      if doesFileExist(fpath) then
        local f = io.open(fpath, 'r')
        if f then
          local info = decodeJson(f:read('*a'))
          local updateversion = info.version_num
          f:close()
          os.remove(fpath)
          if updateversion > thisScript().version_num then
            return true
          end
        end
      end
    end
  end)
end


-- Загрузка обновления
function update(url)
  downloadUrlToFile(url, thisScript().path, function(_, status1, _, _)
    if status1 == 6 then
      thisScript():reload()
    end
  end)
end


-- Перезагрузка скрипта
function scriptReload()
    thisScript():reload()
    sampAddChatMessage(script_prefix..'{ffffff}Скрипт перезагружен.', -1)
end
