from ranger.gui.colorscheme import ColorScheme
from ranger.gui.color import *

class base(ColorScheme):
    progress_bar_color = 1

    def use(self, context):
        fg, bg, attr = default_colors

        if context.reset:
            return default_colors

        elif context.in_browser:
            if context.selected:
                attr = reverse
            else:
                attr = normal
            if context.empty or context.error:
                fg = 239
                bg = 180
            if context.border:
                fg = 239
            if context.image:
                fg = 12
            if context.video:
                fg = 14
            if context.audio:
                fg = 4
            if context.document:
                fg = 180
            if context.container:
                attr |= bold
                fg = 1
            if context.directory:
                attr |= bold
                fg = 248
            elif context.executable and not \
                    any((context.media, context.container,
                       context.fifo, context.socket)):
                attr |= bold
                fg = 4
            if context.socket:
                fg = 3
                attr |= bold
            if context.fifo or context.device:
                fg = 10
                if context.device:
                    attr |= bold
            if context.link:
                fg = context.good and 180 or 238
                bg = 8
            if context.bad:
                fg = 1
            if context.tag_marker and not context.selected:
                attr |= bold
                if fg in (7, 8):
                    fg = 1
                else:
                    fg = 1
            if not context.selected and (context.cut or context.copied):
                fg = 15
                bg = 8
            if context.main_column:
                if context.selected:
                    attr |= bold
                if context.marked:
                    attr |= bold
                    fg = 8
            if context.badinfo:
                if attr & reverse:
                    bg = 1
                else:
                    fg = 7

        elif context.in_titlebar:
            attr |= bold
            if context.hostname:
                fg = context.bad and 239 or 180
            elif context.directory:
                fg = 239
            elif context.tab:
                if context.good:
                    fg = 4
            elif context.link:
                fg = 9

        elif context.in_statusbar:
            if context.permissions:
                if context.good:
                    fg = 4
                elif context.bad:
                    fg = 14
            if context.marked:
                attr |= bold | reverse
                fg = 180
            if context.message:
                if context.bad:
                    attr |= bold
                    fg = 217
            if context.loaded:
                bg = self.progress_bar_color
            if context.vcsinfo:
                fg = 10
                attr &= ~bold
            if context.vcscommit:
                fg = 5
                attr &= ~bold


        if context.text:
            if context.highlight:
                attr |= reverse

        if context.in_taskview:
            if context.title:
                fg = 216

            if context.selected:
                attr |= reverse

            if context.loaded:
                if context.selected:
                    fg = self.progress_bar_color
                else:
                    bg = self.progress_bar_color


        if context.vcsfile and not context.selected:
            attr &= ~bold
            if context.vcsconflict:
                fg = 11
            elif context.vcschanged:
                fg = 12
            elif context.vcsunknown:
                fg = 13
            elif context.vcsstaged:
                fg = 14
            elif context.vcssync:
                fg = 9
            elif context.vcsignored:
                fg = 180

        elif context.vcsremote and not context.selected:
            attr &= ~bold
            if context.vcssync:
                fg = 1
            elif context.vcsbehind:
                fg = 216
            elif context.vcsahead:
                fg = 9
            elif context.vcsdiverged:
                fg = 11
            elif context.vcsunknown:
                fg = 180

        return fg, bg, attr
