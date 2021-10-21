local imgui = require 'imgui'

EXPORTS = {
    colorThemes = {"Сапфир", "Янтарь", "Изумруд"},

    SwitchColorTheme = function(theme)
        local style = imgui.GetStyle()
        local colors = style.Colors
        local clr = imgui.Col
        local ImVec4 = imgui.ImVec4
        local ImVec2 = imgui.ImVec2

        style.WindowPadding = ImVec2(20, 20)
        style.WindowRounding = 8
        style.ChildWindowRounding = 8
        style.WindowTitleAlign = imgui.ImVec2(0.5, 0.5)
        style.FramePadding = ImVec2(6, 4)
        style.FrameRounding = 5
        style.IndentSpacing = 0
        style.ItemSpacing = ImVec2(8, 3)
        style.ItemInnerSpacing = ImVec2(4, 4)
        style.GrabMinSize = 5
        style.GrabRounding = 8

        if theme == 1 or theme == nil then
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
        elseif theme == 2 then
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
            colors[clr.ScrollbarGrab]          = ImVec4(1.00, 0.75, 0.00, 0.93);
            colors[clr.ScrollbarGrabHovered]   = ImVec4(1.00, 0.75, 0.00, 1.00);
            colors[clr.ScrollbarGrabActive]    = ImVec4(1.00, 0.75, 0.00, 0.67);
            colors[clr.CheckMark]              = ImVec4(1.00, 0.75, 0.00, 1.00);
            colors[clr.SliderGrabActive]       = ImVec4(1.00, 0.75, 0.00, 1.00);
            colors[clr.Button]                 = ImVec4(1.00, 0.75, 0.00, 0.87);
            colors[clr.ButtonHovered]          = ImVec4(1.00, 0.75, 0.00, 1.00);
            colors[clr.ButtonActive]           = ImVec4(1.00, 0.75, 0.00, 0.67);
            colors[clr.Header]                 = ImVec4(1.00, 0.75, 0.00, 0.87);
            colors[clr.HeaderHovered]          = ImVec4(1.00, 0.75, 0.00, 1.00);
            colors[clr.HeaderActive]           = ImVec4(1.00, 0.75, 0.00, 0.67);
            colors[clr.Separator]              = ImVec4(0.26, 0.27, 0.30, 0.80);
            colors[clr.CloseButton]            = ImVec4(0.26, 0.27, 0.30, 0.80);
            colors[clr.CloseButtonHovered]     = ImVec4(0.26, 0.27, 0.30, 1.00);
            colors[clr.CloseButtonActive]      = ImVec4(0.26, 0.27, 0.30, 0.60);
            colors[clr.TextSelectedBg]         = ImVec4(1.00, 0.75, 0.00, 0.31);
        elseif theme == 3 then
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
            colors[clr.ScrollbarGrab]          = ImVec4(0.20, 0.72, 0.42, 0.93);
            colors[clr.ScrollbarGrabHovered]   = ImVec4(0.20, 0.72, 0.42, 1.00);
            colors[clr.ScrollbarGrabActive]    = ImVec4(0.20, 0.72, 0.42, 0.67);
            colors[clr.CheckMark]              = ImVec4(0.20, 0.72, 0.42, 1.00);
            colors[clr.SliderGrabActive]       = ImVec4(0.20, 0.72, 0.42, 1.00);
            colors[clr.Button]                 = ImVec4(0.20, 0.72, 0.42, 0.87);
            colors[clr.ButtonHovered]          = ImVec4(0.20, 0.72, 0.42, 1.00);
            colors[clr.ButtonActive]           = ImVec4(0.20, 0.72, 0.42, 0.67);
            colors[clr.Header]                 = ImVec4(0.20, 0.72, 0.42, 0.87);
            colors[clr.HeaderHovered]          = ImVec4(0.20, 0.72, 0.42, 1.00);
            colors[clr.HeaderActive]           = ImVec4(0.20, 0.72, 0.42, 0.67);
            colors[clr.Separator]              = ImVec4(0.26, 0.27, 0.30, 0.80);
            colors[clr.CloseButton]            = ImVec4(0.26, 0.27, 0.30, 0.80);
            colors[clr.CloseButtonHovered]     = ImVec4(0.26, 0.27, 0.30, 1.00);
            colors[clr.CloseButtonActive]      = ImVec4(0.26, 0.27, 0.30, 0.60);
            colors[clr.TextSelectedBg]         = ImVec4(0.20, 0.72, 0.42, 0.31);
        end

    end
}