{-# LANGUAGE KindSignatures #-}
{-# LANGUAGE RankNTypes #-}

import Data.List                            (elemIndex)
import Data.Maybe                           (fromJust)
import Data.Monoid                          (All)
import qualified Data.Map                   as M

import System.Exit                          (exitSuccess)
import qualified System.IO                  as IO

import XMonad
import XMonad.Actions.CycleWS               (Direction1D (..), WSType (..),
                                             moveTo, nextWS, prevWS, toggleWS,
                                             shiftToNext, shiftToPrev)
import XMonad.Actions.SpawnOn               (manageSpawn, spawnHere, spawnAndDo)
import XMonad.Actions.GridSelect as GS
import XMonad.Config.Desktop                (desktopConfig, desktopLayoutModifiers)
import qualified XMonad.Hooks.ManageHelpers as MH
import XMonad.Hooks.DynamicLog              as DL
import XMonad.Hooks.DynamicHooks            (dynamicMasterHook)
import XMonad.Hooks.UrgencyHook             (focusHook, withUrgencyHook)
import XMonad.Hooks.EwmhDesktops
import XMonad.Hooks.ManageDocks             (docksEventHook, manageDocks)
import XMonad.Hooks.SetWMName

import qualified XMonad.StackSet            as W

import XMonad.Util.EZConfig                 as EZ
import XMonad.Util.Run                      (spawnPipe)
import XMonad.Util.NamedScratchpad

import XMonad.Layout.Spacing
import XMonad.Layout.NoBorders              (smartBorders, withBorder, noBorders)
import XMonad.Layout.WindowNavigation       (Direction2D (..), Navigate (..),
                                             windowNavigation)
import XMonad.Layout.Fullscreen             (fullscreenFull)
import XMonad.Layout.TrackFloating

main :: IO()
main = do
--    panelHandle    <- spawnPipe "dzen2 -x 0 -y 0 -h 30 -ta l -w 920 -fg '#f2f2f2' -bg '#000000' -fn 'Roboto Mono-10' -p -e 'onstart=lower' -dock"
--    _              <- spawnPipe "~/.xmonad/dzen/status_bar '#f2f2f2' '#000000' 'Roboto Mono-11'"
    _ <- spawnPipe "/usr/bin/polybar example"
    xmonad $ baseConfig {
        keys            = \conf -> EZ.mkKeymap conf (myKeyBindings conf),
        layoutHook      = myLayout,
        manageHook      = myManageHook
                            <+> namedScratchpadManageHook myScratchpads
                            <+> manageDocks
                            <+> dynamicMasterHook
                            <+> manageHook baseConfig,
        handleEventHook = fullscreenEventHook
                            <+> docksEventHook
                            <+> handleEventHook baseConfig,
        logHook         = logHook baseConfig,
        startupHook     = startupHook baseConfig
                           <+> myStartupHook
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

myWorkspaces = ["home", "web", "code", "media", "game"]

myScratchpads = [
  NS "IM" "/usr/bin/rambox" (className =? "Rambox") (customFloating $ W.RationalRect (1/6)(1/8)(2/3)(3/4)),
  NS "tmux" "urxvtc -name 'urxvt-dropdown' -e 'tmux'" (resource =? "urxvt-dropdown") (customFloating $ W.RationalRect (0)(30/1080)(1)(2/5)),
  NS "scratchpad" "urxvtc -name 'scratchpad'" (resource =? "scratchpad") (customFloating $ W.RationalRect 0.3 0.3 0.4 0.4)]

myKeyBindings :: forall (l :: * -> *). XConfig l -> [(String, X ())]
myKeyBindings conf =
    -- Spawning
    [ ("M-<Return>", spawnHere $ terminal conf)
    , ("M-S-<Return>", spawnHere "urxvtc -name 'urxvt-float'")
    , ("M-r", spawnHere "urxvtc -name 'urxvt-float' -e 'ranger'")
    , ("M-z", spawnHere "zeal")
    , ("M-e", spawn "emacsclient -c")
    , ("M1-S-3", spawn "mixx -f")
    , ("M1-S-4", spawn "sleep 0.5; mixx -s")
    , ("M1-S-6", spawn "sleep 0.5; mixx -v")
    , ("M-l", spawn "xsecurelock auth_pam_x11 saver_blank")
    , ("M-<Space>", spawn myLauncher)
    , ("M-b", spawn "/home/detlev/.xmonad/dzen/sc /home/detlev/.xmonad/dzen/scripts/dzen_battery.sh")
    , ("M-p", spawn "rofi -show pass -theme $SCRIPTDIR/Rofi/Themes/detvdael.rasi")
    , ("M-m", namedScratchpadAction myScratchpads "scratchpad")
    , ("M-o", namedScratchpadAction myScratchpads "IM")
    , ("M-j", namedScratchpadAction myScratchpads "tmux")
    , ("M-u", spawn "mpc toggle")

    -- Quit XMonad
    , ("M-S-c", io exitSuccess)
    -- Restart XMonad
    , ("M-c", spawn "xmonad --recompile; killall -9 polybar; xmonad --restart")

    -- Layout
    , ("M-f", sendMessage NextLayout)
    , ("M-s", withFocused $ windows . toggleFloat)

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
    , ("C-M1-<Right>", moveTo Next NonEmptyWS)
    , ("C-M1-<Left>", moveTo Prev NonEmptyWS)

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
    -- , ("<XF85MonBrightnessUp>", spawn "xbacklight -dec 10")
    -- , ("<XF86MonBrightnessDown>", spawn "xbacklight -inc 10")
    , ("M-<F5>", spawn "xbacklight -dec 10")
    , ("M-<F6>", spawn "xbacklight -inc 10")
    ]

myLauncher :: String
myLauncher = "rofi -show drun -theme ~/Documents/Scripts/Rofi/Themes/detvdael.rasi"

myLayout = myLayoutModifiers myLayouts
myLayoutModifiers = trackFloating
                    . desktopLayoutModifiers
                    . smartBorders
                    . windowNavigation
myLayouts = (tallLayout) ||| fullscreenFull Full
            where tallLayout = Tall 1 (3/100) (1/2)
-- Gapped layout : (smartSpacing 15 $ tallLayout)

myManageHook :: ManageHook
myManageHook = composeAll
    [ manageSpawn
    -- Floats
    , MH.isDialog                          --> doFloat
    , MH.isFullscreen                      --> MH.doFullFloat
    , resource =? "urxvt-float"            --> MH.doRectFloat(W.RationalRect 0.3 0.3 0.4 0.4)
    , resource =? "urxvt-dropdown"         --> MH.doRectFloat(W.RationalRect (0)(30/1080)(1)(1/3))
    , resource =? "mpv-youtube"            --> MH.doFullFloat <+> doShift (myWorkspaces !! 1)
    , resource =? "Toplevel"               --> MH.doRectFloat(W.RationalRect (9/20)(9/20)(11/20)(11/20))
    , className =? "Pinentry"              --> doFloat
    -- Shifts
    , className =? "Rambox"             --> doF W.focusDown
    , className =? "Icecat"             --> doShift (myWorkspaces !! 1)
    , className =? "Firefox"            --> doShift (myWorkspaces !! 1)
    , className =? "FirefoxNightly"     --> doShift (myWorkspaces !! 1)
    , className =? "Waterfox"           --> doShift (myWorkspaces !! 1)
    , className =? "Emacs"              --> doShift (myWorkspaces !! 2)
    , className =? "Code"               --> doShift (myWorkspaces !! 2)
    , className =? "mpv"                --> doShift (myWorkspaces !! 3)
    , resource =? "libreoffice"         --> doShift (myWorkspaces !! 3)
    , className =? "Steam"              --> doShift (myWorkspaces !! 4)
    , className =? "Gimp-2.8"           --> doShift (myWorkspaces !! 5)
    ]

myStartupHook :: X ()
myStartupHook = do
   EZ.checkKeymap baseConfig (myKeyBindings baseConfig)
   setWMName "LG3D"
   fixEWMH

fixEWMH :: X ()
fixEWMH = withDisplay $ \dpy -> do
   wm <- asks theRoot

   atomType <- getAtom "ATOM"
   cardinalType <- getAtom "CARDINAL"

   supportProp <- getAtom "_NET_SUPPORTED"
   desktopGeometryProp <- getAtom "_NET_DESKTOP_GEOMETRY"
   fullscreenSupport <- getAtom "_NET_WM_STATE_FULLSCREEN"

   io $ do
       changeProperty32 dpy wm supportProp atomType propModeAppend
                        [fromIntegral fullscreenSupport,
                         fromIntegral desktopGeometryProp]
       windowAttributes <- getWindowAttributes dpy wm
       let width = fromIntegral $ wa_width windowAttributes
           height = fromIntegral $ wa_height windowAttributes
       changeProperty32 dpy wm desktopGeometryProp cardinalType propModeReplace
                        [width, height]

-- Allows toggling floats instead of separate float and sink
toggleFloat :: Ord a => a -> W.StackSet i l a s sd -> W.StackSet i l a s sd
toggleFloat w s@W.StackSet{W.floating = floating}
    | w `M.member` floating      = s { W.floating = M.delete w floating }
    | otherwise = s { W.floating = M.insert w (W.RationalRect 0.3 0.3 0.4 0.4) floating }
