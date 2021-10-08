script_name = 'Moon AutoLogin' -- Название скрипта
script_prefix = '{068aff}[Moon AutoLogin] {ffffff}' -- Префикс скрипта
script_author = 'ASKIT' -- Автор скрипта
script_version = '09.10.21' -- Версия скрипта
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
        pass1 = '',
        pass2 = ''
    }
})

-- Исправление кодировки.
encoding.default = 'cp1251'
local u8 = encoding.UTF8
local function recode(u8) return encoding.UTF8:decode(u8) end

---------------------
local mainWindowState = imgui.ImBool(false)

local active = imgui.ImBool(cfg.settings.active)
local pass1 = imgui.ImBuffer(cfg.settings.pass1, 32)
local pass2 = imgui.ImBuffer(cfg.settings.pass2, 32)
---------------------


function main()
    if not isSampLoaded() or not isSampfuncsLoaded() then return end
    autoupdate('https://raw.githubusercontent.com/oASKITo/moonstd/main/Moon%20AutoLogin/version.json', script_prefix, 'https://vk.com/moonstd')
    while not isSampAvailable() do wait(100) end

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
        imgui.Begin(script_name..' '..script_version, mainWindowState, imgui.WindowFlags.NoResize + imgui.WindowFlags.NoTitleBar + imgui.WindowFlags.AlwaysAutoResize)

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
            imgui.SetCursorPosX((imgui.GetWindowWidth() - imgui.CalcTextSize(u8'Окей').x)/2-20)
            if imgui.Button(u8'Окей', imgui.ImVec2(80, 20)) then
                mainWindowState.v = false
                imgui.Process = false
            end

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
    }, getWorkingDirectory() .. "Moon AutoLogin.ini")
end

-- Авто-обновление. Автор: http://qrlk.me/samp
function autoupdate(json_url, prefix, url)
  local dlstatus = require('moonloader').download_status
  local json = getWorkingDirectory() .. '\\'..thisScript().name..'-version.json'
  if doesFileExist(json) then os.remove(json) end
  downloadUrlToFile(json_url, json,
    function(id, status, p1, p2)
      if status == dlstatus.STATUSEX_ENDDOWNLOAD then
        if doesFileExist(json) then
          local f = io.open(json, 'r')
          if f then
            local info = decodeJson(f:read('*a'))
            updatelink = info.updateurl
            updateversion = info.latest
            f:close()
            os.remove(json)
            if updateversion ~= script_version then
              lua_thread.create(function(prefix)
                local dlstatus = require('moonloader').download_status
                local color = -1
                sampAddChatMessage((prefix..'Обнаружено обновление. Пытаюсь обновиться c '..script_version..' на '..updateversion), color)
                wait(250)
                downloadUrlToFile(updatelink, thisScript().path,
                  function(id3, status1, p13, p23)
                    if status1 == dlstatus.STATUS_DOWNLOADINGDATA then
                      print(string.format('Загружено %d из %d.', p13, p23))
                    elseif status1 == dlstatus.STATUS_ENDDOWNLOADDATA then
                      print('Загрузка обновления завершена.')
                      sampAddChatMessage((prefix..'Обновление завершено!'), color)
                      goupdatestatus = true
                      lua_thread.create(function() wait(500) thisScript():reload() end)
                    end
                    if status1 == dlstatus.STATUSEX_ENDDOWNLOAD then
                      if goupdatestatus == nil then
                        sampAddChatMessage((prefix..'Обновление прошло неудачно. Запускаю устаревшую версию..'), color)
                        update = false
                      end
                    end
                  end
                )
                end, prefix
              )
            else
              update = false
              print('v'..script_version..': Обновление не требуется.')
            end
          end
        else
          print('v'..script_version..': Не могу проверить обновление. Смиритесь или проверьте самостоятельно на '..url)
          update = false
        end
      end
    end
  )
  while update ~= false do wait(100) end
end


-- Перезагрузка скрипта
function scriptReload()
    thisScript():reload()
    sampAddChatMessage(script_prefix..'Скрипт перезагружен.', -1)
end