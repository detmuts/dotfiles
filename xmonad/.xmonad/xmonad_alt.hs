-- myWorkspaces = map (clickable . DL.dzenEscape) wsList
--   where
--     clickable ws = DL.wrap ("^ca(1,wmctrl -s " ++ show (wsid ws) ++ ")") "^ca()" . DL.pad $ ws
--     wsid w = fromJust $ elemIndex w wsList
--     wsList = ["HOME", "WEB", "CODE", "MEDIA"] ++ map show ([5..9] :: [Int])

--    panelHandle    <- spawnPipe "dzen2 -x 0 -y 0 -h 30 -ta l -w 920 -fg '#f2f2f2' -bg '#000000' -fn 'Roboto Mono-10' -p -e 'onstart=lower' -dock"
--    _              <- spawnPipe "~/.xmonad/dzen/status_bar '#f2f2f2' '#000000' 'Roboto Mono-11'"

myWorkspaces = map (clickable . DL.dzenEscape) wsList
  where
    clickable ws = DL.wrap ("^ca(1,wmctrl -s " ++ show (wsid ws) ++ ")") "^ca()" . DL.pad $ ws
    wsid w = fromJust $ elemIndex w wsList
    wsList = ["HOME", "WEB", "CODE", "MEDIA"] ++ map show ([5..9] :: [Int])

myLogHook :: IO.Handle -> X ()
myLogHook panelHandle = DL.dynamicLogWithPP $ def
    { DL.ppCurrent              = \ws -> DL.dzenColor foreground background $ ws
    , DL.ppVisible              = \ws -> DL.dzenColor color3 background $ ws
    , DL.ppHidden               = \ws -> DL.dzenColor color3 background $ ws
    , DL.ppHiddenNoWindows      = \ws -> DL.dzenColor color2 background $ ws
    , DL.ppUrgent               = \ws -> DL.dzenColor color1 background $ ws
    , DL.ppTitle                = \_ -> ""
    , DL.ppLayout               = \_ -> ""
    , DL.ppWsSep                = ""
    , DL.ppSep                  = ""
    , DL.ppOrder                = \(ws:_:_:_) -> [ws]
    , DL.ppOutput               = IO.hPutStrLn panelHandle
    }

background = "#000000"
foreground = "#f2f2f2"
color1 =  "#bf616a"
color2 = "#667175"
color3 = "#8a919e"

addFullscreenSupport :: X ()
addFullscreenSupport = withDisplay $ \dpy -> do
    wm                <- asks theRoot
    supportProp       <- getAtom "_NET_SUPPORTED"
    atomType          <- getAtom "ATOM"
    fullscreenSupport <- getAtom "_NET_WM_STATE_FULLSCREEN"
    io $ changeProperty32 dpy wm supportProp atomType propModeAppend [fromIntegral fullscreenSupport]

