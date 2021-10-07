script_name = 'Moon Visor' -- Название скрипта
script_prefix = '{068aff}[Moon Visor] {ffffff}' -- Префикс скрипта
script_author = 'ASKIT' -- Автор скрипта
script_version = '07.10.21' -- Версия скрипта
script_site = 'vk.com/moonstd' -- Сайт

require "lib.moonloader"
local sampev = require('lib.samp.events')
local wm = require 'lib.windows.message' -- Библиотека с оконными сообщениями
local vkeys = require 'vkeys' -- Библиотека с клавишами
local imgui = require 'imgui'
local encoding = require 'encoding'
encoding.default = 'cp1251'
local u8 = encoding.UTF8
local inicfg = require 'inicfg'
local direct_cfg = '../moonstd/Moon Visor.ini'
local cfg = inicfg.load(inicfg.load({
    settings = {
        script_enabled = false,
        script_hothey = 88,
        effect_nightVision = false,
        effect_infraredVision = false,
        use_roleplay = false,
        use_animation = false,
        rp_onVisor = u8('активировал визор в режиме ночного видения.'),
        rp_toggleVisor = u8('переключил визор в режим инфрокрасного зрения.'),
        rp_offVisor = u8('отключил визор.'),
    },
}, direct_cfg))
inicfg.save(cfg, direct_cfg)

--========================================--
local resX, resY = getScreenResolution()

-- Окна
local mainWindowState = imgui.ImBool(false)

-- Настройки
local script_enabled = imgui.ImBool(cfg.settings.script_enabled)
local script_hothey = imgui.ImInt(cfg.settings.script_hothey)
local effect_nightVision = imgui.ImBool(cfg.settings.effect_nightVision)
local effect_thermalVision = imgui.ImBool(cfg.settings.effect_infraredVision)
local use_roleplay = imgui.ImBool(cfg.settings.use_roleplay)
local use_animation = imgui.ImBool(cfg.settings.use_animation)
local rp_onVisor = imgui.ImBuffer(cfg.settings.rp_onVisor, 256)
local rp_toggleVisor = imgui.ImBuffer(cfg.settings.rp_toggleVisor, 256)
local rp_offVisor = imgui.ImBuffer(cfg.settings.rp_offVisor, 256)
--========================================--


function main()
    if not isSampLoaded() or not isSampfuncsLoaded() then return end
    while not isSampAvailable() do wait(100) end

    -- Команды
        sampRegisterChatCommand('mv', cmd_mv)

    -- Функции
        visor()

end


-- Основная команда
function cmd_mv(arg)

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
        imgui.ShowCursor = true
        imgui.SetNextWindowPos(imgui.ImVec2(resX/2, resY/2), 2, imgui.ImVec2(0.5, 0.5))
        imgui.Begin(script_name..' '..script_version..' by '..script_author, mainWindowState, imgui.WindowFlags.NoResize + imgui.WindowFlags.AlwaysAutoResize + imgui.WindowFlags.NoCollapse)

            if imgui.Checkbox(u8'Активировать скрипт', script_enabled) then
                cfg.settings.script_enabled = script_enabled.v
                inicfg.save(cfg)
            end
            imgui.Question(u8'Активируйте скрипт, чтобы использовать визор')
            imgui.SameLine()
            imgui.PushItemWidth(30)
            if imgui.InputInt(u8'Клавиша активации визора', script_hothey, 0, 0) then
                cfg.settings.script_hothey = script_hothey.v
                inicfg.save(cfg)
            end
            imgui.SameLine()
            if imgui.Link(u8"(?)", u8"Перейти на сайт, для просмотра номеров клавиш") then
                os.execute(('explorer.exe "%s"'):format('https://www.blast.hk/threads/8760/'))
            end
            imgui.Spacing()
            imgui.Spacing()
            imgui.Separator()
            imgui.Spacing()
            if imgui.Checkbox(u8'Ролеплей отыгровки', use_roleplay) then
                cfg.settings.use_roleplay = use_roleplay.v
                inicfg.save(cfg)
            end
            imgui.SameLine()
            if imgui.Checkbox(u8'Анимация', use_animation) then
                cfg.settings.use_animation = use_animation.v
                inicfg.save(cfg)
            end
            imgui.Question(u8'Анимация надевания визора')
            if cfg.settings.use_roleplay then
                imgui.PushItemWidth(340)
                imgui.Text('/me')
                imgui.SameLine()
                if imgui.InputTextWithHint(u8'##rp_onVisor', u8'Включение визора', rp_onVisor) then
                    cfg.settings.rp_onVisor = rp_onVisor.v
                    inicfg.save(cfg)
                end
                imgui.Text('/me')
                imgui.SameLine()
                if imgui.InputTextWithHint(u8'##rp_toggleVisor', u8'Переключение визора', rp_toggleVisor) then
                    cfg.settings.rp_toggleVisor = rp_toggleVisor.v
                    inicfg.save(cfg)
                end
                imgui.Text('/me')
                imgui.SameLine()
                if imgui.InputTextWithHint(u8'##rp_offVisor', u8'Отключение визора', rp_offVisor) then
                    cfg.settings.rp_offVisor = rp_offVisor.v
                    inicfg.save(cfg)
                end
            end

        imgui.End()
        imgui.Process = mainWindowState.v
    end

end

function visor()
    lua_thread.create(function()
        while true do wait(0)
            setNightVision(cfg.settings.effect_nightVision)
            setInfraredVision(cfg.settings.effect_infraredVision)

            if cfg.settings.script_enabled then
                if isKeyJustPressed(cfg.settings.script_hothey) and not sampIsChatInputActive() and not sampIsDialogActive() and not isSampfuncsConsoleActive() then
                    if not cfg.settings.effect_nightVision and not cfg.settings.effect_nightVision then
                        if cfg.settings.use_animation and not isCharInAnyCar(PLAYER_PED) then taskPlayAnim(PLAYER_PED, 'GOGGLES_PUT_ON', 'GOGGLES', 4.0, false, false, false, false) end
                        if not isCharInAnyCar(PLAYER_PED) then wait(1000) end
                        if cfg.settings.use_roleplay then sampSendChat('/me '..u8:decode(cfg.settings.rp_onVisor)) end
                        cfg.settings.effect_nightVision = true
                    elseif cfg.settings.effect_nightVision and not cfg.settings.effect_infraredVision then
                        if cfg.settings.use_animation and not isCharInAnyCar(PLAYER_PED) then taskPlayAnim(PLAYER_PED, 'GOGGLES_PUT_ON', 'GOGGLES', 4.0, false, false, false, false) end
                        if not isCharInAnyCar(PLAYER_PED) then wait(1000) end
                        if cfg.settings.use_roleplay then sampSendChat('/me '..u8:decode(cfg.settings.rp_toggleVisor)) end
                        cfg.settings.effect_infraredVision = true
                    elseif cfg.settings.effect_nightVision and cfg.settings.effect_infraredVision then
                        if cfg.settings.use_animation and not isCharInAnyCar(PLAYER_PED) then taskPlayAnim(PLAYER_PED, 'GOGGLES_PUT_ON', 'GOGGLES', 4.0, false, false, false, false) end
                        if not isCharInAnyCar(PLAYER_PED) then wait(1000) end
                        if cfg.settings.use_roleplay then sampSendChat('/me '..u8:decode(cfg.settings.rp_offVisor)) end
                        cfg.settings.effect_nightVision = false
                        cfg.settings.effect_infraredVision = false

                    end
                end
            end

        end
    end)
end


-- Подсказка на Button/InputText/Checkbox
function imgui.Question(text)
    if imgui.IsItemHovered() then
        imgui.BeginTooltip()
        imgui.PushTextWrapPos(450)
        imgui.TextUnformatted(text)
        imgui.PopTextWrapPos()
        imgui.EndTooltip() 
    end 
end


-- Закрытие окна ImGui на ESC
function onWindowMessage(msg, wparam, lparam)

    if wparam == vkeys.VK_ESCAPE and mainWindowState.v then
        if msg == wm.WM_KEYDOWN then
            consumeWindowMessage(true, false)
        end
        if msg == wm.WM_KEYUP then
            mainWindowState.v = false
            imgui.ShowCursor = false
        end
    end

end


-- Ссылка
function imgui.Link(label, description)

    local size = imgui.CalcTextSize(label)
    local p = imgui.GetCursorScreenPos()
    local p2 = imgui.GetCursorPos()
    local result = imgui.InvisibleButton(label, size)

    imgui.SetCursorPos(p2)

    if imgui.IsItemHovered() then
        if description then
            imgui.BeginTooltip()
            imgui.PushTextWrapPos(600)
            imgui.TextUnformatted(description)
            imgui.PopTextWrapPos()
            imgui.EndTooltip()

        end

        imgui.TextColored(imgui.GetStyle().Colors[imgui.Col.CheckMark], label)
        imgui.GetWindowDrawList():AddLine(imgui.ImVec2(p.x, p.y + size.y), imgui.ImVec2(p.x + size.x, p.y + size.y), imgui.GetColorU32(imgui.GetStyle().Colors[imgui.Col.CheckMark]))

    else
        imgui.TextColored(imgui.GetStyle().Colors[imgui.Col.CheckMark], label)
    end

    return result
end


-- Placeholder для InputText
-- Использование: imgui.InputTextWithHint(u8"Текст", "Подсказка", im_buffer)
function imgui.InputTextWithHint(label, hint, buf, flags, callback, user_data)
    local l_pos = {imgui.GetCursorPos(), 0}
    local handle = imgui.InputText(label, buf, flags, callback, user_data)
    l_pos[2] = imgui.GetCursorPos()
    local t = (type(hint) == 'string' and buf.v:len() < 1) and hint or '\0'
    local t_size, l_size = imgui.CalcTextSize(t).x, imgui.CalcTextSize('A').x
    imgui.SetCursorPos(imgui.ImVec2(l_pos[1].x + 8, l_pos[1].y + 2))
    imgui.TextDisabled((imgui.CalcItemWidth() and t_size > imgui.CalcItemWidth()) and t:sub(1, math.floor(imgui.CalcItemWidth() / l_size)) or t)
    imgui.SetCursorPos(l_pos[2])
    return handle
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


-- Сохранение конфига
function saveData()
    inicfg.save({
        settings =
        {
            script_enabled = cfg.settings.script_enabled,
            script_hothey = cfg.settings.script_hothey,
            effect_nightVision = cfg.settings.effect_nightVision,
            effect_infraredVision = cfg.settings.effect_infraredVision,
            use_roleplay = cfg.settings.use_roleplay,
            use_animation = cfg.settings.use_animation,
            rp_onVisor = cfg.settings.rp_onVisor,
            rp_toggleVisor = cfg.settings.rp_toggleVisor,
            rp_offVisor = cfg.settings.rp_offVisor,
        }
    })
end


-- Перезагрузка скрипта
function scriptReload()
    thisScript():reload()
    sampAddChatMessage(script_prefix..'Скрипт перезагружен.', -1)
end


-- Кастомизация стилей
function apply_custom_style()
    imgui.SwitchContext()
    local style = imgui.GetStyle()
    style.WindowTitleAlign = imgui.ImVec2(0.5, 0.5)
end
apply_custom_style()