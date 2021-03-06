script_name = 'Moon Visor'
script_prefix = '{068aff}[Moon Visor] {ffffff}'
script_author = 'ASKIT'
script_version = '10.10.21'
script_site = 'vk.com/moonstd'

require "lib.moonloader"
local sampev = require('lib.samp.events')
local wm = require 'lib.windows.message'
local vkeys = require 'vkeys'
local imgui = require 'imgui'
local icon = require 'faIcons'
-- ??????????? ?????????.
local encoding = require 'encoding'
local u8 = encoding.UTF8
encoding.default = 'cp1251'
local function recode(u8) return encoding.UTF8:decode(u8) end
--
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
        rp_onVisor = u8('??????????? ????? ? ?????? ??????? ???????.'),
        rp_toggleVisor = u8('?????????? ????? ? ????? ????????????? ??????.'),
        rp_offVisor = u8('???????? ?????.'),
    },
}, direct_cfg))
inicfg.save(cfg, direct_cfg)


local font_14 = nil
local font_22 = nil
local icon_font_14 = nil
local icon_font_22 = nil


--========================================--
local resX, resY = getScreenResolution()

-- ????
local mainWindowState = imgui.ImBool(false)

-- ?????????
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
    autoupdate('https://www.dropbox.com/s/em6w3grwsv8dk6v/version.json?dl=0', script_prefix, 'https://vk.com/moonstd')
    while not isSampAvailable() do wait(100) end

    -- ???????
        sampRegisterChatCommand('mv', cmd_mv)

    -- ???????
        visor()

end


-- ???????? ???????
function cmd_mv(arg)

    if arg == '' then
        mainWindowState.v = not mainWindowState.v
        imgui.Process = mainWindowState.v

    elseif arg == 'reload' then
        scriptReload()
    end

end


-- ????????? ???????.
function imgui.BeforeDrawFrame()

    local icon_glyph_ranges = imgui.ImGlyphRanges({ icon.min_range, icon.max_range })
    local font_config = imgui.ImFontConfig()
    font_config.MergeMode = true

    if font_14 == nil then
        font_14 = imgui.GetIO().Fonts:AddFontFromFileTTF(getFolderPath(0x14)..'\\trebucbd.ttf', 14, nil, imgui.GetIO().Fonts:GetGlyphRangesCyrillic()) 
        icon_font_14 = imgui.GetIO().Fonts:AddFontFromFileTTF('moonloader/resource/fonts/fa-solid-900.ttf', 14.0, font_config, icon_glyph_ranges) 
    end 
    if font_22 == nil then
        font_22 = imgui.GetIO().Fonts:AddFontFromFileTTF(getFolderPath(0x14)..'\\trebucbd.ttf', 22, nil, imgui.GetIO().Fonts:GetGlyphRangesCyrillic()) 
        icon_font_22 = imgui.GetIO().Fonts:AddFontFromFileTTF('moonloader/resource/fonts/fa-solid-900.ttf', 22.0, font_config, icon_glyph_ranges) 
    end 
end


-- ????????? ImGui
function imgui.OnDrawFrame()

    if mainWindowState.v then
        imgui.ShowCursor = true
        imgui.SetNextWindowPos(imgui.ImVec2(resX/2, resY/2), 2, imgui.ImVec2(0.5, 0.5))
        imgui.Begin(script_name..' '..script_version..' by '..script_author, mainWindowState, imgui.WindowFlags.NoResize + imgui.WindowFlags.AlwaysAutoResize + imgui.WindowFlags.NoCollapse)

            imgui.PushFont(font_14)

            if imgui.Checkbox(u8'???????????? ??????', script_enabled) then
                cfg.settings.script_enabled = script_enabled.v
                inicfg.save(cfg)
            end
            imgui.Question(u8'??????????? ??????, ????? ???????????? ?????')
            imgui.PushItemWidth(30)
            if imgui.InputInt(u8'??????? ????????? ??????', script_hothey, 0, 0) then
                cfg.settings.script_hothey = script_hothey.v
                inicfg.save(cfg)
            end
            imgui.Spacing()
            imgui.Separator()
            imgui.Spacing()
            if imgui.Checkbox(u8'???????? ?????????', use_roleplay) then
                cfg.settings.use_roleplay = use_roleplay.v
                inicfg.save(cfg)
            end
            imgui.SameLine()
            if imgui.Checkbox(u8'????????', use_animation) then
                cfg.settings.use_animation = use_animation.v
                inicfg.save(cfg)
            end
            imgui.Question(u8'???????? ????????? ??????')
            imgui.Spacing()
            imgui.PushItemWidth(340)
            imgui.Text('/me')
            imgui.SameLine()
            if imgui.InputTextWithHint(u8'##rp_onVisor', u8'????????? ??????', rp_onVisor) then
                cfg.settings.rp_onVisor = rp_onVisor.v
                inicfg.save(cfg)
            end
            imgui.Text('/me')
            imgui.SameLine()
            if imgui.InputTextWithHint(u8'##rp_toggleVisor', u8'???????????? ??????', rp_toggleVisor) then
                cfg.settings.rp_toggleVisor = rp_toggleVisor.v
                inicfg.save(cfg)
            end
            imgui.Text('/me')
            imgui.SameLine()
            if imgui.InputTextWithHint(u8'##rp_offVisor', u8'?????????? ??????', rp_offVisor) then
                cfg.settings.rp_offVisor = rp_offVisor.v
                inicfg.save(cfg)
            end

            imgui.PopFont()

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


-- ????????? ?? Button/InputText/Checkbox
function imgui.Question(text)
    if imgui.IsItemHovered() then
        imgui.BeginTooltip()
        imgui.PushTextWrapPos(450)
        imgui.TextUnformatted(text)
        imgui.PopTextWrapPos()
        imgui.EndTooltip() 
    end 
end


-- ???????? ???? ImGui ?? ESC
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


-- ??????
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


-- Placeholder ??? InputText
-- ?????????????: imgui.InputTextWithHint(u8"?????", "?????????", im_buffer)
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


-- ????-??????????. ?????: http://qrlk.me/samp
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
                sampAddChatMessage((prefix..'?????????? ??????????. ??????? ?????????? c '..script_version..' ?? '..updateversion), color)
                wait(250)
                downloadUrlToFile(updatelink, thisScript().path,
                  function(id3, status1, p13, p23)
                    if status1 == dlstatus.STATUS_DOWNLOADINGDATA then
                      print(string.format('????????? %d ?? %d.', p13, p23))
                    elseif status1 == dlstatus.STATUS_ENDDOWNLOADDATA then
                      print('???????? ?????????? ?????????.')
                      sampAddChatMessage((prefix..'?????????? ?????????!'), color)
                      goupdatestatus = true
                      lua_thread.create(function() wait(500) thisScript():reload() end)
                    end
                    if status1 == dlstatus.STATUSEX_ENDDOWNLOAD then
                      if goupdatestatus == nil then
                        sampAddChatMessage((prefix..'?????????? ?????? ????????. ???????? ?????????? ??????..'), color)
                        update = false
                      end
                    end
                  end
                )
                end, prefix
              )
            else
              update = false
              print('v'..script_version..': ?????????? ?? ?????????.')
            end
          end
        else
          print('v'..script_version..': ?? ???? ????????? ??????????. ????????? ??? ????????? ?????????????? ?? '..url)
          update = false
        end
      end
    end
  )
  while update ~= false do wait(100) end
end


-- ?????????? ???????
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


-- ???????????? ???????
function scriptReload()
    thisScript():reload()
    sampAddChatMessage(script_prefix..'?????? ????????????.', -1)
end


-- ???????????? ??????
function apply_custom_style()
    imgui.SwitchContext()
    local style = imgui.GetStyle()
    local colors = style.Colors
    local clr = imgui.Col
    local ImVec4 = imgui.ImVec4
    local ImVec2 = imgui.ImVec2

    style.WindowPadding = ImVec2(20, 20)
    style.WindowRounding = 16
    style.WindowTitleAlign = imgui.ImVec2(0.5, 0.5)
    style.FramePadding = ImVec2(6, 4)
    style.FrameRounding = 5
    style.ItemSpacing = ImVec2(8, 3)
    style.ItemInnerSpacing = ImVec2(4, 4)
    style.GrabMinSize = 5
    style.GrabRounding = 16

    colors[clr.Text]                   = ImVec4(1.00, 1.00, 1.00, 1.00);
    colors[clr.WindowBg]               = ImVec4(0.00, 0.00, 0.00, 0.67);
    colors[clr.PopupBg]                = ImVec4(0.16, 0.17, 0.20, 0.80);
    colors[clr.Border]                 = ImVec4(0.26, 0.27, 0.30, 0.80);
    colors[clr.FrameBg]                = ImVec4(0.16, 0.17, 0.20, 0.80);
    colors[clr.FrameBgHovered]         = ImVec4(0.16, 0.17, 0.20, 1.00);
    colors[clr.FrameBgActive]          = ImVec4(0.16, 0.17, 0.20, 0.67);
    colors[clr.TitleBg]                = ImVec4(0.16, 0.17, 0.20, 0.93);
    colors[clr.TitleBgActive]          = ImVec4(0.16, 0.17, 0.20, 1.00);
    colors[clr.TitleBgCollapsed]       = ImVec4(0.16, 0.17, 0.20, 0.67);
    colors[clr.ScrollbarBg]            = ImVec4(0.16, 0.17, 0.20, 0.80);
    colors[clr.ScrollbarGrab]          = ImVec4(0.18, 0.56, 1.00, 0.93);
    colors[clr.ScrollbarGrabHovered]   = ImVec4(0.18, 0.56, 1.00, 1.00);
    colors[clr.ScrollbarGrabActive]    = ImVec4(0.18, 0.56, 1.00, 0.67);
    colors[clr.CheckMark]              = ImVec4(0.18, 0.56, 1.00, 1.00);
    colors[clr.SliderGrabActive]       = ImVec4(0.18, 0.56, 1.00, 1.00);
    colors[clr.Button]                 = ImVec4(0.18, 0.56, 1.00, 0.87);
    colors[clr.ButtonHovered]          = ImVec4(0.18, 0.56, 1.00, 1.00);
    colors[clr.ButtonActive]           = ImVec4(0.18, 0.56, 1.00, 0.67);
    colors[clr.Header]                 = ImVec4(0.18, 0.56, 1.00, 0.87);
    colors[clr.HeaderHovered]          = ImVec4(0.18, 0.56, 1.00, 1.00);
    colors[clr.HeaderActive]           = ImVec4(0.18, 0.56, 1.00, 0.67);
    colors[clr.Separator]              = ImVec4(0.26, 0.27, 0.30, 0.80);
    colors[clr.CloseButton]            = ImVec4(0.26, 0.27, 0.30, 0.80);
    colors[clr.CloseButtonHovered]     = ImVec4(0.26, 0.27, 0.30, 1.00);
    colors[clr.CloseButtonActive]      = ImVec4(0.26, 0.27, 0.30, 0.60);
    colors[clr.TextSelectedBg]         = ImVec4(0.18, 0.56, 1.00, 0.31);
end
apply_custom_style()