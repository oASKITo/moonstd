script_name = 'Moon Toolbox' -- �������� �������.
script_prefix = '{068aff}[Moon Toolbox] {ffffff}' -- ������� �������.
script_author = 'ASKIT' -- ����� �������.
script_version = '09.10.21' -- ������ �������.
script_site = 'vk.com/moonstd' -- ����.

require "lib.moonloader"
local sampev = require('lib.samp.events')
local wm = require 'lib.windows.message' -- ���������� � �������� �����������.
local vkeys = require 'vkeys' -- ���������� � ���������.
local imgui = require 'imgui'
local encoding = require 'encoding'
local icon = require 'faIcons'
local inicfg = require 'inicfg'
local direct_cfg = '../moonstd/Moon Toolbox.ini'
local cfg = inicfg.load(inicfg.load({
    settings = {
        active = false
    },
    main = {
        user_adminLevel = 0,
        account_password = '',
        admin_password = '',
        account_autoLogin = false,
        admin_autoLogin = false,
        --
        timeWidget_enabled = false,
        timeWidget_fontColor = '{ffffff}',
        timeWidget_posX = 0,
        timeWidget_posY = 0,
    },
    recon = {
        fastExit = false,
        fastExit_key1 = 16,
        fastExit_key2 = 81,
        fastEnter_inVeh = false,
        exitText_delete = false,
        interface_customPos = false,
        interface_customLang = false,
    },
}, direct_cfg))
inicfg.save(cfg, direct_cfg)

-- ����������� ���������.
encoding.default = 'cp1251'
local u8 = encoding.UTF8
local function recode(u8) return encoding.UTF8:decode(u8) end

local selectedTab = 1
local account_showPassword = true
local admin_showPassword = true
local font = nil
local icon_font = nil

--========================================--
-- ����.
local window_main = imgui.ImBool(false)
local window_timeWidget = imgui.ImBool(cfg.main.timeWidget_enabled)
local window_timeWidgetSettings = imgui.ImBool(false)

-- ��������.
local user_adminLevel = imgui.ImInt(cfg.main.user_adminLevel)
local account_autoLogin = imgui.ImBool(cfg.main.account_autoLogin)
local admin_autoLogin = imgui.ImBool(cfg.main.admin_autoLogin)
local admin_password = imgui.ImBuffer(cfg.main.admin_password, 32)
local account_password = imgui.ImBuffer(cfg.main.account_password, 32)
--
local timeWidget_enabled = imgui.ImBool(cfg.main.timeWidget_enabled)
local timeWidget_fontColor = imgui.ImBuffer(cfg.main.timeWidget_fontColor, 9)
local timeWidget_posX = imgui.ImInt(cfg.main.timeWidget_posX)
local timeWidget_posY = imgui.ImInt(cfg.main.timeWidget_posY)

-- �����.
local fastExit = imgui.ImBool(cfg.recon.fastExit)
local fastExit_key1 = imgui.ImInt(cfg.recon.fastExit_key1)
local fastExit_key2 = imgui.ImInt(cfg.recon.fastExit_key2)
local fastEnter_inVeh = imgui.ImBool(cfg.recon.fastEnter_inVeh)
local exitText_delete = imgui.ImBool(cfg.recon.exitText_delete)
local interface_customPos = imgui.ImBool(cfg.recon.interface_customPos)
local interface_customLang = imgui.ImBool(cfg.recon.interface_customLang)

imgui.Process = window_timeWidget.v
--========================================--


function main()
    if not isSampLoaded() or not isSampfuncsLoaded() then return end
    autoupdate('https://raw.githubusercontent.com/oASKITo/moonstd/main/Moon%20Toolbox/version.json', script_prefix, 'https://vk.com/moonstd')
    while not isSampAvailable() do wait(100) end

    -- �������.
        sampRegisterChatCommand("mtb", cmd_mtb)
        sampRegisterChatCommand("re", cmd_re)

    -- �������.
        autoLogin()
        keyPass()
        textdrawEdit()

end


-- �������� �������.
function cmd_mtb(arg)

    if arg == '' then
        window_main.v = not window_main.v
        imgui.Process = window_main.v

    elseif arg == 'reload' then
        scriptReload()
    end

end


-- ����� �� ��.
function cmd_re(id)
    lua_thread.create(function()

        id = tonumber(id)

        if id >= 0 and isCharInAnyCar(playerPed) and cfg.recon.fastEnter_inVeh then
            local x, y, z = getCharCoordinates(playerPed)
            warpCharFromCarToCoord(playerPed, x, y, z)
            wait(20)
            sampSendChat('/re '..id)
        elseif id >= 0 then
            sampSendChat('/re '..id)
        end

    end)
end


-- ��������� �������.
function imgui.BeforeDrawFrame()

    if icon_font == nil then
        local icon_glyph_ranges = imgui.ImGlyphRanges({ icon.min_range, icon.max_range })
        local font_config = imgui.ImFontConfig()
        font_config.MergeMode = true
        
        icon_font = imgui.GetIO().Fonts:AddFontFromFileTTF('moonloader/resource/fonts/fa-solid-900.ttf', 13.0, font_config, icon_glyph_ranges) 
    end
end

-- ��������� �������.
function imgui.BeforeDrawFrame()

    if icon_font == nil then
        local icon_glyph_ranges = imgui.ImGlyphRanges({ icon.min_range, icon.max_range })
        local font_config = imgui.ImFontConfig()
        font_config.MergeMode = true
        
        icon_font = imgui.GetIO().Fonts:AddFontFromFileTTF('moonloader/resource/fonts/fa-solid-900.ttf', 13.0, font_config, icon_glyph_ranges) 
    end
    if font == nil then
        font = imgui.GetIO().Fonts:AddFontFromFileTTF(getFolderPath(0x14)..'\\trebucbd.ttf', 22, nil, imgui.GetIO().Fonts:GetGlyphRangesCyrillic()) 
    end 
end


-- ��������� ImGui.
function imgui.OnDrawFrame()

    unix_time = os.time(os.date('!*t'))
    moscow_time = unix_time + 3 * 60 * 60

    if window_main.v then
        imgui.ShowCursor = true
        local resX, resY = getScreenResolution()
        imgui.SetNextWindowSize(imgui.ImVec2(720, 400), 2)
        imgui.SetNextWindowPos(imgui.ImVec2(resX/2, resY/2), 2, imgui.ImVec2(0.5, 0.5))
        imgui.Begin(script_name..' '..script_version..' by '..script_author, window_main, imgui.WindowFlags.NoResize)
        imgui.BeginGroup()
            imgui.BeginChild('Selectable', imgui.ImVec2(200, 0), true)
                if imgui.Selectable(u8'�������� ���������', selectedTab == 1) then selectedTab = 1 end
                if imgui.Selectable(u8'��������� ������', selectedTab == 2) then selectedTab = 2 end
                if imgui.Selectable(u8'������-���', selectedTab == 3) then selectedTab = 3 end
            imgui.EndChild()
        imgui.EndGroup()

        imgui.SameLine()
        -- �������� ���������.
        if selectedTab == 1 then
            imgui.BeginGroup()
                imgui.BeginChild('main', imgui.ImVec2(595, 0), true)

                    if user_adminLevel ~= 0 then
                        imgui.TextColoredRGB('{00ffaa}�� ���������������� ��� ������������� '..cfg.main.user_adminLevel..' ������.')
                    else
                        imgui.TextColoredRGB('{ff3399}��� ���������� ������ ������ ���������� �������������� ��� �������������.')
                    end

                    imgui.Spacing() imgui.Separator() imgui.Spacing()

                    if imgui.Checkbox('##account_autoLogin', account_autoLogin) then
                        cfg.main.account_autoLogin = account_autoLogin.v
                        inicfg.save(cfg)
                    end
                    imgui.Question(u8'�������������� ����������� �� �������')
                    imgui.SameLine()
                    imgui.PushItemWidth(170)
                    if imgui.InputText(u8'������ �� ��������', account_password, imgui.InputTextFlags.Password) then
                        cfg.main.account_password = account_password.v
                        inicfg.save(cfg)
                    end
                    if imgui.Checkbox('##admin_autoLogin', admin_autoLogin) then
                        cfg.main.admin_autoLogin = admin_autoLogin.v
                        inicfg.save(cfg)
                    end
                    imgui.Question(u8'�������������� ����������� � �����-������')
                    imgui.SameLine()
                    imgui.PushItemWidth(170)
                    if imgui.InputText(u8'������ �� �������', admin_password, imgui.InputTextFlags.Password) then
                        cfg.main.admin_password = admin_password.v
                        inicfg.save(cfg)
                    end

                    imgui.Spacing() imgui.Separator() imgui.Spacing()

                    if imgui.Checkbox(u8'����������� �������', timeWidget_enabled) then
                        cfg.main.timeWidget_enabled = timeWidget_enabled.v
                        window_timeWidget.v = not window_timeWidget.v
                        inicfg.save(cfg)
                    end
                    imgui.Question(u8'���������� ������ �������.\n\n��� �������������� � �������� - ������� �� ���� ���.\n��� ��������� ������� - �������������� ��� � ������� ���.')

                imgui.EndChild()
            imgui.EndGroup()
        end

        -- ��������� ������.
        if selectedTab == 2 then
            imgui.BeginGroup()
                imgui.BeginChild('recon', imgui.ImVec2(595, 0), true)

                    if imgui.Checkbox(u8'##fastExit', fastExit) then
                        cfg.recon.fastExit = fastExit.v
                        inicfg.save(cfg)
                    end
                    imgui.Question(u8'����� �� ������ �� �������, � ������� ������������� ������.\n\n��� ��������� ������� ������ ����������� �� ����.\n�� ������ ���������� ���� �������, ���� ������ ���������� ���� � ����.')
                    imgui.SameLine()
                    imgui.PushItemWidth(30)
                    if imgui.InputInt(u8'##fastExit_key1', fastExit_key1, 0, 0) then
                        cfg.recon.fastExit_key1 = fastExit_key1.v
                        inicfg.save(cfg)
                    end
                    imgui.SameLine()
                    imgui.Text(u8'+')
                    imgui.SameLine()
                    imgui.PushItemWidth(30)
                    if imgui.InputInt(u8'##fastExit_key2', fastExit_key2, 0, 0) then
                        cfg.recon.fastExit_key2 = fastExit_key2.v
                        inicfg.save(cfg)
                    end
                    if imgui.Checkbox(u8'������� �����', fastEnter_inVeh) then
                        cfg.recon.fastEnter_inVeh = fastEnter_inVeh.v
                        inicfg.save(cfg)
                    end
                    imgui.Question(u8'�� ��������� ������� � �����, �������� � ������������ �������� - ����������. ������ ���� ���������� ��� �������������.')
                    if imgui.Checkbox(u8'���� ������ �� ��', exitText_delete) then
                        cfg.recon.exitText_delete = exitText_delete.v
                        inicfg.save(cfg)
                    end
                    imgui.Question(u8'������� ����������� ����� ����� ������ �� ������.')
                    if imgui.Checkbox(u8'����� ������ �� ������', exitText_delete) then
                        cfg.recon.exitText_delete = exitText_delete.v
                        inicfg.save(cfg)
                    end
                    imgui.Question(u8'������� ����������� ����� ����� ������ �� ������.')
                    if imgui.Checkbox(u8'���� ����������', interface_customPos) then
                        cfg.recon.interface_customPos = interface_customPos.v
                        inicfg.save(cfg)
                    end
                    imgui.Question(u8'��������� ������� ���������� ������.')
                    if imgui.Checkbox(u8'�����������', interface_customLang) then
                        cfg.recon.interface_customLang = interface_customLang.v
                        inicfg.save(cfg)
                    end
                    imgui.Question(u8'��������� ����� ���������� �� ������� ����.')


                imgui.EndChild()
            imgui.EndGroup()
        end
        -- ������-���.
        if selectedTab == 3 then
            imgui.BeginGroup()
                imgui.BeginChild('cheats', imgui.ImVec2(595, 0), true)

                    imgui.Text(u8'�����')

                imgui.EndChild()
            imgui.EndGroup()
        end

        imgui.End()
    end

    -- ������ �������.
    if window_timeWidget.v then
        imgui.SetNextWindowPos(imgui.ImVec2(cfg.main.timeWidget_posX, cfg.main.timeWidget_posY), imgui.Cond.FirstUseEver)
        imgui.Begin('##window_timeWidget', window_timeWidget, imgui.WindowFlags.NoResize + imgui.WindowFlags.NoTitleBar + imgui.WindowFlags.AlwaysAutoResize)
            
            imgui.PushFont(font) 
                imgui.SetCursorPosX((imgui.GetWindowWidth() - imgui.CalcTextSize(os.date('%H:%M:%S %d.%m.%y'), moscow_time).x)/2)
                imgui.TextColoredRGB(os.date(cfg.main.timeWidget_fontColor..'%H:%M:%S %d.%m.%y'), moscow_time) 
            imgui.PopFont()

            if imgui.IsRootWindowOrAnyChildHovered() then
                if not imgui.IsMouseDown(0) then
                  
                    local window_pos = imgui.GetWindowPos()
                    cfg.main.timeWidget_posX = window_pos.x
                    cfg.main.timeWidget_posY = window_pos.y
                    inicfg.save(cfg)
                end 
            end

            if (imgui.IsMouseClicked(1) and imgui.IsWindowHovered()) then
                window_timeWidgetSettings.v = not window_timeWidgetSettings.v
            end

        imgui.End() 
    end


    -- ��������� ������� �������.
    if window_timeWidgetSettings.v then
        imgui.Begin('##window_timeWidget', window_timeWidgetSettings, imgui.WindowFlags.NoResize + imgui.WindowFlags.NoTitleBar + imgui.WindowFlags.AlwaysAutoResize)

            imgui.Spacing()
            imgui.Separator()
            imgui.Spacing()

            imgui.PushItemWidth(50)
            if imgui.InputText(u8' ���� ������', timeWidget_fontColor) then
                cfg.main.timeWidget_fontColor = timeWidget_fontColor.v
                inicfg.save(cfg)
            end

        imgui.End() 
    end

    if window_main.v then imgui.ShowCursor = true else imgui.ShowCursor = false end
    if not window_main.v and not sampIsChatInputActive() then window_timeWidgetSettings.v = false end

end


-- �������������� �����������.
function autoLogin()
    lua_thread.create(function()
        while true do wait(0)
            if cfg.main.account_autoLogin and cfg.main.account_password ~= nil then -- ������ �� ��������
                if sampIsDialogActive() ~= 0 then
                    if current_dialog == '1' then
                        sampSetCurrentDialogEditboxText(cfg.main.account_password)
                        sampCloseCurrentDialogWithButton(1)
                        current_dialog = '0'
                    end
                end
            end
            if cfg.main.admin_autoLogin and cfg.main.admin_password ~= nil then -- ������ �� �������
                if sampIsDialogActive() ~= 0 then
                    if current_dialog == '2' then
                        sampSetCurrentDialogEditboxText(cfg.main.admin_password)
                        sampCloseCurrentDialogWithButton(1)
                        current_dialog = '0'
                    end
                end
            end
        end
    end)
end


-- ��������� �������.
function keyPass()
    lua_thread.create(function()
        while true do wait(0)
            
            -- ������� ����� �� ������.
                if user_isRecon and cfg.recon.fastExit and isKeyJustPressed(cfg.recon.fastExit_key1) and isKeyJustPressed(cfg.recon.fastExit_key2) and not sampIsChatInputActive() and not sampIsDialogActive() and not isSampfuncsConsoleActive() then
                    sampSendChat('/reoff')
                end

        end
    end)
end

-- �������� �������.
function sampev.onShowDialog(id, style, title, button1, button2, text)

    -- ��� autoLogin()
    if title == '{B789CF}�����������' or title == '�����������' then
        current_dialog = '1'
    elseif text == '{FFFFFF}������� ������ ��������������:' then
        current_dialog = '2'

    end

end


-- ����� �����.
function sampev.onServerMessage(color, text)
    if current_dialog == '2' and text:find('�� ���������������� ��� ������������� (%d) ������') then
        cfg.main.user_adminLevel = tonumber(text:match('%d'))
        inicfg.save(cfg)
    end
end


-- ��������� �� ������.
function imgui.Question(text)
    if imgui.IsItemHovered() then
        imgui.BeginTooltip()
        imgui.PushTextWrapPos(450)
        imgui.TextUnformatted(text)
        imgui.PopTextWrapPos()
        imgui.EndTooltip() 
    end 
end


-- �������� ���� ImGui �� ESC.
function onWindowMessage(msg, wparam, lparam)

    if wparam == vkeys.VK_ESCAPE and window_main.v then
        if msg == wm.WM_KEYDOWN then
            consumeWindowMessage(true, false)
        end
        if msg == wm.WM_KEYUP then
            window_main.v = false
            imgui.ShowCursor = false
        end
    end

end


-- �������������� �����������.
function textdrawEdit()

    lua_thread.create(function()
        while true do wait(0)

            if cfg.recon.interface_customPos then
                ---------------------- ����� ������.
                sampTextdrawSetPos(199, 5.5991560220718, 159.60740661621)
                --
                sampTextdrawSetPos(200, 6.9654740095139, 161.35179138184)
                sampTextdrawSetPos(201, 6.9654740095139, 175.35264587402)
                sampTextdrawSetPos(202, 6.9654740095139, 189.05349731445)
                sampTextdrawSetPos(203, 6.9654740095139, 202.55438232422)
                sampTextdrawSetPos(204, 6.9654740095139, 216.25526428223)
                sampTextdrawSetPos(205, 6.9654740095139, 230.05610656738)
                sampTextdrawSetPos(206, 6.9654740095139, 243.7569732666)
                sampTextdrawSetPos(207, 6.9654740095139, 257.45767211914)
                sampTextdrawSetPos(208, 6.9654740095139, 271.65853881836)
                --
                sampTextdrawSetPos(209, 29.433361053467, 162.66296386719)
                sampTextdrawSetPos(210, 29.433361053467, 176.26315307617)
                sampTextdrawSetPos(211, 29.433361053467, 189.9640045166)
                sampTextdrawSetPos(212, 29.433361053467, 203.56491088867)
                sampTextdrawSetPos(213, 29.433361053467, 217.66577148438)
                sampTextdrawSetPos(214, 29.433361053467, 231.26664733887)
                sampTextdrawSetPos(215, 29.433361053467, 244.96752929688)
                sampTextdrawSetPos(216, 29.433361053467, 258.56817626953)
                sampTextdrawSetPos(217, 29.433361053467, 272.96905517578)
                --
                sampTextdrawSetPos(2052, 29.400733947754, 286.59942626953)
                ---------------------- ������ ������.
                sampTextdrawSetPos(187, 552.29736328125, 155.58518981934)
                sampTextdrawSetPos(188, 552.19873046875, 155.58518981934)
                sampTextdrawSetPos(189, 550.66558837891, 149.23330688477)
                sampTextdrawSetPos(190, 620.06561279297, 149.13331604004)
                sampTextdrawSetPos(191, 556.13226318359, 151.28137207031)
                sampTextdrawSetPos(192, 550.66558837891, 286.33306884766)
                sampTextdrawSetPos(193, 619.86352539063, 286.33306884766)
                sampTextdrawSetPos(194, 556.63067626953, 288.69982910156)
                sampTextdrawSetPos(195, 552.33093261719, 287.96667480469)
                sampTextdrawSetPos(196, 551.66674804688, 158.91854858398)
                sampTextdrawSetPos(197, 560.89837646484, 166.59213256836)
                sampTextdrawSetPos(198, 560.89837646484, 225.17710876465)
                sampTextdrawSetPos(2049, 590.73474121094, 154.89978027344)
                sampTextdrawSetPos(2050, 602.89813232422, 166.1773223877)
                sampTextdrawSetPos(2051, 602.79797363281, 225.17710876465)
            else
                ---------------------- ����� ������.
                sampTextdrawSetPos(199, 5.5991560220718-5, 159.60740661621)
                --
                sampTextdrawSetPos(200, 6.9654740095139-5, 161.35179138184)
                sampTextdrawSetPos(201, 6.9654740095139-5, 175.35264587402)
                sampTextdrawSetPos(202, 6.9654740095139-5, 189.05349731445)
                sampTextdrawSetPos(203, 6.9654740095139-5, 202.55438232422)
                sampTextdrawSetPos(204, 6.9654740095139-5, 216.25526428223)
                sampTextdrawSetPos(205, 6.9654740095139-5, 230.05610656738)
                sampTextdrawSetPos(206, 6.9654740095139-5, 243.7569732666)
                sampTextdrawSetPos(207, 6.9654740095139-5, 257.45767211914)
                sampTextdrawSetPos(208, 6.9654740095139-5, 271.65853881836)
                --
                sampTextdrawSetPos(209, 29.433361053467-5, 162.66296386719)
                sampTextdrawSetPos(210, 29.433361053467-5, 176.26315307617)
                sampTextdrawSetPos(211, 29.433361053467-5, 189.9640045166)
                sampTextdrawSetPos(212, 29.433361053467-5, 203.56491088867)
                sampTextdrawSetPos(213, 29.433361053467-5, 217.66577148438)
                sampTextdrawSetPos(214, 29.433361053467-5, 231.26664733887)
                sampTextdrawSetPos(215, 29.433361053467-5, 244.96752929688)
                sampTextdrawSetPos(216, 29.433361053467-5, 258.56817626953)
                sampTextdrawSetPos(217, 29.433361053467-5, 272.96905517578)
                --
                sampTextdrawSetPos(2052, 29.400733947754-5, 286.59942626953)
                ---------------------- ������ ������.
                sampTextdrawSetPos(187, 552.29736328125+10, 155.58518981934)
                sampTextdrawSetPos(188, 552.19873046875+10, 155.58518981934)
                sampTextdrawSetPos(189, 550.66558837891+10, 149.23330688477)
                sampTextdrawSetPos(190, 620.06561279297+10, 149.13331604004)
                sampTextdrawSetPos(191, 556.13226318359+10, 151.28137207031)
                sampTextdrawSetPos(192, 550.66558837891+10, 286.33306884766)
                sampTextdrawSetPos(193, 619.86352539063+10, 286.33306884766)
                sampTextdrawSetPos(194, 556.63067626953+10, 288.69982910156)
                sampTextdrawSetPos(195, 552.33093261719+10, 287.96667480469)
                sampTextdrawSetPos(196, 551.66674804688+10, 158.91854858398)
                sampTextdrawSetPos(197, 560.89837646484+5, 166.59213256836)
                sampTextdrawSetPos(198, 560.89837646484+5, 225.17710876465)
                sampTextdrawSetPos(2049, 590.73474121094+10, 154.89978027344)
                sampTextdrawSetPos(2050, 602.89813232422+5, 166.1773223877)
                sampTextdrawSetPos(2051, 602.79797363281+5, 225.17710876465)
            end

            -- if cfg.recon.interface_customLang then

            --     sampTextdrawSetString(209, '��������') --
            --     sampTextdrawSetString(210, 'C�A�.') --
            --     sampTextdrawSetString(211, '�����') --

            --     -- textData = {
            --     --     {'�', 'A'},
            --     --     {'�', '�'},
            --     --     {'�', '�'},
            --     --     {'�', '�'},
            --     --     {'�', '�'},
            --     --     {'�', '�'},
            --     --     {'�', 'E'},
            --     --     {'�', '�'},
            --     --     {'�', '�'},
            --     --     {'�', '�'},
            --     --     {'�', '�'},
            --     --     {'�', '�'},
            --     --     {'�', '�'},
            --     --     {'�', '�'},
            --     --     {'�', '�'},
            --     --     {'�', '�'},
            --     --     {'�', '�'},
            --     --     {'�', '�'},
            --     --     {'�', 'C'},
            --     --     {'�', '�'},
            --     --     {'�', '�'},
            --     --     {'�', '�'},
            --     --     {'�', '�'},
            --     --     {'�', '�'},
            --     --     {'�', '�'},
            --     --     {'�', '�'},
            --     --     {'�', '�'},
            --     --     {'�', '�'},
            --     --     {'�', '�'},
            --     --     {'�', '�'},
            --     --     {'�', ''},
            --     --     {'�', '�'},
            --     --     {'�', '�'},
            --     -- }

            -- end

        end
    end)
end


-- ����-����������. �����: http://qrlk.me/samp
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
                sampAddChatMessage((prefix..'���������� ����������. ������� ���������� c '..script_version..' �� '..updateversion), color)
                wait(250)
                downloadUrlToFile(updatelink, thisScript().path,
                  function(id3, status1, p13, p23)
                    if status1 == dlstatus.STATUS_DOWNLOADINGDATA then
                      print(string.format('��������� %d �� %d.', p13, p23))
                    elseif status1 == dlstatus.STATUS_ENDDOWNLOADDATA then
                      print('�������� ���������� ���������.')
                      sampAddChatMessage((prefix..'���������� ���������!'), color)
                      goupdatestatus = true
                      lua_thread.create(function() wait(500) thisScript():reload() end)
                    end
                    if status1 == dlstatus.STATUSEX_ENDDOWNLOAD then
                      if goupdatestatus == nil then
                        sampAddChatMessage((prefix..'���������� ������ ��������. �������� ���������� ������..'), color)
                        update = false
                      end
                    end
                  end
                )
                end, prefix
              )
            else
              update = false
              print('v'..script_version..': ���������� �� ���������.')
            end
          end
        else
          print('v'..script_version..': �� ���� ��������� ����������. ��������� ��� ��������� �������������� �� '..url)
          update = false
        end
      end
    end
  )
  while update ~= false do wait(100) end
end


-- ������� �����
function imgui.TextColoredRGB(text)
    local style = imgui.GetStyle()
    local colors = style.Colors
    local ImVec4 = imgui.ImVec4

    local explode_argb = function(argb)
        local a = bit.band(bit.rshift(argb, 24), 0xFF)
        local r = bit.band(bit.rshift(argb, 16), 0xFF)
        local g = bit.band(bit.rshift(argb, 8), 0xFF)
        local b = bit.band(argb, 0xFF)
        return a, r, g, b 
    end

    local getcolor = function(color)
        if color:sub(1, 6):upper() == 'SSSSSS' then
            local r, g, b = colors[1].x, colors[1].y, colors[1].z
            local a = tonumber(color:sub(7, 8), 16) or colors[1].w * 255
            return ImVec4(r, g, b, a / 255)
        end
        local color = type(color) == 'string' and tonumber(color, 16) or color
        if type(color) ~= 'number' then return end
        local r, g, b, a = explode_argb(color)
        return imgui.ImColor(r, g, b, a):GetVec4() 
    end

    local render_text = function(text_)
        for w in text_:gmatch('[^\r\n]+') do
            local text, colors_, m = {}, {}, 1
            w = w:gsub('{(......)}', '{%1FF}')
            while w:find('{........}') do
                local n, k = w:find('{........}')
                local color = getcolor(w:sub(n + 1, k - 1))
                if color then
                    text[#text], text[#text + 1] = w:sub(m, n - 1), w:sub(k + 1, #w)
                    colors_[#colors_ + 1] = color
                    m = n 
                end
                w = w:sub(1, n - 1) .. w:sub(k + 1, #w) 
            end
            if text[0] then
                for i = 0, #text do
                    imgui.TextColored(colors_[i] or colors[1], u8(text[i]))
                    imgui.SameLine(nil, 0) 
                end
                imgui.NewLine()
            else imgui.Text(u8(w)) 
            end 
        end 
    end

    render_text(text) 
end


-- S A M P - E V E N T S ===================================
function sampev.onTogglePlayerSpectating(state)
    if state then user_isRecon = true else user_isRecon = false end
    toggle = user_isRecon
end

function sampev.onDisplayGameText(style, time, text)

    if cfg.recon.exitText_delete then
        if text == '~w~RECON ~r~ OFF~n~ ~g~SPECTATE' then
            return false
        end
    end

end
-- S A M P - E V E N T S ===================================


-- ���������� �������.
function saveData()
    inicfg.save({
        settings =
        {
            active = cfg.settings.active
        },
        main =
        {
            user_adminLevel = cfg.main.user_adminLevel,
            account_autoLogin = cfg.main.account_autoLogin,
            admin_autoLogin = cfg.main.admin_autoLogin,
            account_password = cfg.main.account_password,
            admin_password = cfg.main.admin_password,
            --
            timeWidget_enabled = cfg.main.timeWidget_enabled,
            timeWidget_fontColor = cfg.main.timeWidget_fontColor,
            timeWidget_posX = cfg.main.timeWidget_posX,
            timeWidget_posY = cfg.main.timeWidget_posY,
        },
        recon =
        {
            fastExit = cfg.recon.fastExit,
            fastExit_key1 = cfg.recon.fastExit_key1,
            fastExit_key2 = cfg.recon.fastExit_key2,
            fastEnter_inVeh = cfg.recon.fastEnter_inVeh,
            exitText_delete = cfg.recon.exitText_delete,
            interface_customPos = cfg.recon.interface_customPos,
            interface_customLang = cfg.recon.interface_customLang,
        },
    })
end


-- ������������ �������.
function scriptReload()
    thisScript():reload()
    sampAddChatMessage(script_prefix..'������ ������������.', -1)
end