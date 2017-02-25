{-# LANGUAGE KindSignatures #-}
{-# LANGUAGE RankNTypes #-}

import Data.List                            (elemIndex)
import Data.Maybe                           (fromJust)
import Data.Monoid                          (All)
import qualified Data.Map                   as M

import System.Exit                          (exitSuccess)
import System.IO                            as IO

import XMonad
import XMonad.Actions.CycleWS               (Direction1D (..), WSType (..),
                                             moveTo, nextWS, prevWS, toggleWS,
                                             shiftToNext, shiftToPrev)
import XMonad.Actions.SpawnOn               (manageSpawn, spawnHere, spawnAndDo)
import XMonad.Actions.GridSelect as GS
import XMonad.Config.Desktop                (desktopConfig, desktopLayoutModifiers)
import qualified XMonad.Hooks.DynamicLog    as DL
import qualified XMonad.Hooks.ManageHelpers as MH
import XMonad.Hooks.DynamicHooks            (dynamicMasterHook)
import XMonad.Hooks.UrgencyHook             (focusHook, withUrgencyHook)
import XMonad.Hooks.EwmhDesktops            (fullscreenEventHook)
import XMonad.Hooks.ManageDocks             (docksEventHook, manageDocks)

import qualified XMonad.StackSet            as W

import XMonad.Util.EZConfig                 as EZ
import XMonad.Util.Run                      (spawnPipe)
import XMonad.Util.Scratchpad
-- import XMonad.Util.NamedScratchpad

import XMonad.Layout.Spacing
import XMonad.Layout.NoBorders              (smartBorders, withBorder, noBorders)
import XMonad.Layout.WindowNavigation       (Direction2D (..), Navigate (..),
                                             windowNavigation)
import XMonad.Layout.Fullscreen             (fullscreenFull)
import XMonad.Layout.TrackFloating
import XMonad.Layout.MultiToggle
import XMonad.Layout.MultiToggle.Instances

main :: IO()
main = do
    panelHandle    <- spawnPipe "dzen2 -x 0 -y 0 -h 30 -ta l -w 920 -fg '#f2f2f2' -bg '#000000' -fn 'Roboto Mono-10' -p -e 'onstart=lower' -dock"
    -- _              <- spawnPipe "~/.xmonad/dzen/status_bar '#f2f2f2' '#2b303b' 'Roboto Mono-11'"
    _              <- spawnPipe "~/.xmonad/dzen/status_bar '#f2f2f2' '#000000' 'Roboto Mono-11'"

    xmonad $ withUrgencyHook focusHook $ baseConfig {
        keys            = \conf -> EZ.mkKeymap conf (myKeyBindings conf),
        layoutHook      = myLayout,
        manageHook      = myScratchpadManageHook <+> manageDocks <+> myManageHook <+> dynamicMasterHook <+> manageHook baseConfig,
        handleEventHook = myEventHook <+> handleEventHook baseConfig,
        logHook         = myLogHook panelHandle <+> logHook baseConfig,
        startupHook     = startupHook baseConfig <+> myStartupHook
    }

baseConfig = desktopConfig {
    terminal           = "urxvtc",
    focusFollowsMouse  = False,
    clickJustFocuses   = False,
    modMask            = mod4Mask,
    borderWidth        = 1,
    normalBorderColor  = "#2b303b",
    focusedBorderColor = "#c0c5ce",
    workspaces         = myWorkspaces
    }

myWorkspaces :: [String]
myWorkspaces = map (clickable . DL.dzenEscape) wsList
  where
    clickable ws = DL.wrap ("^ca(1,wmctrl -s " ++ show (wsid ws) ++ ")") "^ca()" . DL.pad $ ws
    wsid w = fromJust $ elemIndex w wsList
    wsList = ["HOME", "WEB", "CODE", "MEDIA"] ++ map show ([5..9] :: [Int])

myKeyBindings :: forall (l :: * -> *). XConfig l -> [(String, X ())]
myKeyBindings conf =
    -- Spawning
    [ ("M-<Return>", spawnHere $ terminal conf)
    , ("M-S-<Return>", spawnHere "urxvtc -name 'urxvt-float'")
    , ("M-r", spawnHere "urxvtc -name 'urxvt-float' -e 'ranger'")
    , ("M-e", spawn "emacsclient -c")
    , ("M1-S-3", spawn "mixx -f")
    , ("M1-S-4", spawn "sleep 0.5; mixx -s")
    , ("M1-S-5", spawn "sleep 0.5; mixx -v")
    , ("M-l", spawn "xsecurelock auth_pam_x11 saver_blank")
    , ("M-<Space>", spawn myLauncher)
    , ("M-m", scratchpadSpawnAction conf)
    , ("M-b", spawn "/home/detlev/.xmonad/dzen/sc /home/detlev/.xmonad/dzen/scripts/dzen_battery.sh")
    , ("M-p", spawn "rofi -show pass -theme $SCRIPTDIR/Rofi/Themes/detvdael.rasi")
    , ("M-g", goToSelected GS.def)
    , ("M-k", bringSelected GS.def)

    -- Quit XMonad
    , ("M-S-c", io exitSuccess)
    -- Restart XMonad
    , ("M-c", spawn "xmonad --recompile; killall dzen2; xmonad --restart")

    -- Layout
    , ("M-f", sendMessage NextLayout)
    , ("M-s", withFocused $ windows . toggleFloat)
    , ("M-z", sendMessage $ Toggle NBFULL)

    -- Focus
    , ("M-<Tab>", windows W.focusDown)
    , ("M-S-<Tab>", windows W.focusUp)
    , ("M-<Up>", sendMessage $ Go U)
    , ("M-<Down>", sendMessage $ Go D)
    , ("M-<Left>", sendMessage $ Go L)
    , ("M-<Right>", sendMessage $ Go R)

    -- Swap
    , ("M-S-<Up>", sendMessage $ Swap U)
    , ("M-S-<Down>", sendMessage $ Swap D)
    , ("M-S-<Left>", sendMessage $ Swap L)
    , ("M-S-<Right>", sendMessage $ Swap R)

    -- Workspace Controls
    , ("M-n", moveTo Next NonEmptyWS)
    , ("M-t", moveTo Prev NonEmptyWS)

    -- Resizing
    , ("M-C-h", sendMessage Shrink)
    , ("M-C-l", sendMessage Expand)
    , ("M-q", kill)
    ] ++

    -- Workspaces
    [("M-" ++ mask ++ show wsid, windows $ action workspace)
        | (workspace, wsid) <- zip (workspaces conf) ([1..9] :: [Int])
        , (action, mask) <- [(W.greedyView, ""), (W.shift, "S-")]
    ] ++

    -- Multimedia keys
    [ ("<XF86AudioRaiseVolume>", spawn "amixer -c 0 set Master 5+")
    , ("<XF86AudioLowerVolume>", spawn "amixer -c 0 set Master 5-")
    , ("<XF86AudioMute>", spawn "amixer -D pulse set Master Playback Switch toggle")
    -- Not working until kernel 4.10 patch
    --, ("<XF86MonBrightnessUp>", spawn "xbacklight -dec 10")
    --, ("<XF86MonBrightnessDown>", spawn "xbacklight -inc 10")
    , ("M-<F5>", spawn "xbacklight -dec 10")
    , ("M-<F6>", spawn "xbacklight -inc 10")
    ]

myLauncher :: String
myLauncher = "rofi -show drun -theme ~/Documents/Scripts/Rofi/Themes/detvdael.rasi"

myLayout = myLayoutModifiers myLayouts
myLayoutModifiers = desktopLayoutModifiers
                    . smartBorders
                    . windowNavigation
                    . trackFloating
myLayouts = (tallLayout) ||| fullscreenFull Full
            where tallLayout = Tall 1 (3/100) (54/100)
-- Gapped layout : (smartSpacing 15 $ tallLayout)

myScratchpadManageHook :: ManageHook
myScratchpadManageHook = scratchpadManageHook (W.RationalRect 0.3 0.3 0.4 0.4)

myManageHook :: ManageHook
myManageHook = composeAll
    [ manageSpawn
    -- Floats
    , MH.isDialog               --> doFloat
    , MH.isFullscreen           --> MH.doFullFloat
    , resource =? "urxvt-float" --> MH.doCenterFloat
    , resource =? "mpv-youtube" --> MH.doFullFloat <+> doShift (myWorkspaces !! 1)
    -- Shifts
    , className =? "Firefox"    --> doShift (myWorkspaces !! 1)
    , className =? "Waterfox"   --> doShift (myWorkspaces !! 1)
    , className =? "Emacs"      --> doShift (myWorkspaces !! 2)
    , className =? "mpv"        --> doShift (myWorkspaces !! 3)
    , resource =? "libreoffice" --> doShift (myWorkspaces !! 3)
    , className =? "Gimp-2.8"   --> doShift (myWorkspaces !! 4)
    ]

myEventHook :: Event -> X All
myEventHook = fullscreenEventHook <+> docksEventHook

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

myStartupHook :: X ()
myStartupHook = do
    EZ.checkKeymap baseConfig (myKeyBindings baseConfig)
    addFullscreenSupport

addFullscreenSupport :: X ()
addFullscreenSupport = withDisplay $ \dpy -> do
    wm                <- asks theRoot
    supportProp       <- getAtom "_NET_SUPPORTED"
    atomType          <- getAtom "ATOM"
    fullscreenSupport <- getAtom "_NET_WM_STATE_FULLSCREEN"
    io $ changeProperty32 dpy wm supportProp atomType propModeAppend [fromIntegral fullscreenSupport]

-- Allows toggling floats instead of separata float and sink
toggleFloat :: Ord a => a -> W.StackSet i l a s sd -> W.StackSet i l a s sd
toggleFloat w s@W.StackSet{W.floating = floating}
    | w `M.member` floating      = s { W.floating = M.delete w floating }
    | otherwise = s { W.floating = M.insert w (W.RationalRect 0.3 0.3 0.4 0.4) floating }
