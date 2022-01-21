--------------------------------------------------------------------------------
-- | Example.hs
--
-- Example configuration file for xmonad using the latest recommended
-- features (e.g., 'desktopConfig').
module Main (main) where

--------------------------------------------------------------------------------
import System.Exit
import XMonad
--import XMonad.Actions.Volume
import XMonad.Config.Desktop
import XMonad.Hooks.DynamicLog
import XMonad.Hooks.ManageHelpers
import XMonad.Hooks.ManageDocks
import XMonad.Layout.Spacing
import XMonad.Layout.BinarySpacePartition (emptyBSP)
import XMonad.Layout.NoBorders (noBorders)
import XMonad.Layout.ResizableTile (ResizableTall(..))
import XMonad.Layout.ToggleLayouts (ToggleLayout(..), toggleLayouts)
import XMonad.Layout.Circle
import XMonad.Layout.Gaps
import XMonad.Layout.Fullscreen
import XMonad.Layout.NoFrillsDecoration
import XMonad.Prompt
import XMonad.Prompt.ConfirmPrompt
import XMonad.Prompt.Shell
import XMonad.Util.EZConfig
import XMonad.Util.Run
import qualified XMonad.StackSet as W
import System.IO

--layout
ful = noBorders (fullscreenFull Full)
res = ResizableTall 1 (2/100) (2/3) []
gap = gaps [(U, 8), (R, 8), (L, 8), (D, 8)] $ avoidStruts (spacing 2 $ res)

myLayout = gap ||| tiled ||| Mirror tiled ||| ful ||| Circle
	where
		tiled = smartSpacing 7 $ Tall nmaster delta ratio
		nmaster = 1
		ratio = 2/3
		delta = 5/100

myManageHook = composeAll
	[ title =? "pianobar"			--> doShift "4:music"
	, className =? "Chromium"		--> doShift "2:web"
	, className =? "Firefox"		--> doShift "2:web"
	, className =? "libreoffice-startcenter" --> doShift "3:writing"
	, className =? "FocusWriter"		--> doShift "3:writing"
	, className =? "Atom"			--> doShift "5:code"
	, title =? "jekyll-server"		--> doShift "9"
	, title =? "minicom"			--> doShift "6:serial"
	, isDialog				--> doCenterFloat
	, className =? "Thunar"			--> doCenterFloat
	]

myWorkspaces = ["1:term","2:web","3:writing","4:music","5:code","6:serial"] ++ map show [7..9]

--------------------------------------------------------------------------------
-- Colors and borders

xmobarTitleColor = "#c678dd"
xmobarCurrentWorkspaceColor = "#51afef"

myNormalBorderColor = "#000000"
myFocusedBorderColor = active

base03  = "#002b36"
base02  = "#073642"
base01  = "#586e75"
base00  = "#657b83"
base0   = "#839496"
base1   = "#93a1a1"
base2   = "#eee8d5"
base3   = "#fdf6e3"
yellow  = "#b58900"
orange  = "#cb4b16"
red     = "#dc322f"
magenta = "#d33682"
violet  = "#6c71c4"
blue    = "#268bd2"
cyan    = "#2aa198"
green   = "#859900"

active		= blue
activeWarn	= red
inactive	= base02
focusColor	= blue
unfocusColor 	= base02

myLauncher = "rofi -show"

--------------------------------------------------------------------------------
main = do
xmproc <- spawnPipe "/usr/bin/xmobar /home/hbrenum/.xmobarrc"
xmonad $ defaultConfig
	{ startupHook		= do
		--spawn "/usr/bin/xmobar /home/hbrenum/.xmobarrcbot"
		spawn "/home/hbrenum/bin/wallpaper.sh"
	, modMask		= mod4Mask
	, borderWidth		= 2
	, manageHook		= manageDocks <+> myManageHook <+> manageHook desktopConfig
	, layoutHook		= avoidStruts $ myLayout
	, handleEventHook	= handleEventHook defaultConfig <+> docksEventHook
	, logHook		= dynamicLogWithPP xmobarPP
		{ ppOutput	= hPutStrLn xmproc
		, ppCurrent 	= xmobarColor xmobarCurrentWorkspaceColor "" . wrap "[" "]"
		, ppTitle	= xmobarColor xmobarTitleColor "" . shorten 100 --"#ff1493" "" . shorten 100
		, ppLayout	= const "" -- comment out to display layout in xmobar
		, ppSep		= " - "
		}
	, workspaces		= myWorkspaces
	, terminal		= "urxvt"
	, normalBorderColor	= "#343c48" --"#cccccc"
	, focusedBorderColor	= "#6986a0" --"#cd8b00"
	} `additionalKeys`
	[ ((mod4Mask .|. shiftMask	, xK_z		), spawn "slock")
	, ((controlMask			, xK_Print	), spawn "sleep 0.2; scrot -s")
	, ((mod4Mask .|. shiftMask , xK_3	), spawn "scrot")
	, ((mod4Mask .|. shiftMask , xK_4 ), spawn "scrot -s")
	, ((controlMask .|. shiftMask	, xK_m		), spawn "urxvt -name pianobar -e pianobar -c '/usr/bin/pianobar'")
	, ((controlMask .|. shiftMask	, xK_e		), spawn "urxvt -name minicom -e minicom -c '/usr/bin/minicom'")
	, ((mod4Mask .|. shiftMask	, xK_f		), spawn "urxvt -name vifm -e vifm -c '/usr/bin/vifm'")
	, ((0				, xK_Print	), spawn "scrot")
	, ((controlMask .|. shiftMask	, xK_w		), spawn "urxvt -name nano-wc -e nano-wc -c '/usr/local/bin/nano-wc'")
	, ((mod4Mask .|. shiftMask	, xK_b		), spawn "chromium")
	, ((mod4Mask .|. shiftMask	, xK_l		), spawn "libreoffice")
	, ((controlMask .|. shiftMask	, xK_f		), spawn "focuswriter")
	, ((mod4Mask .|. shiftMask	, xK_a		), spawn "atom")
	, ((mod4Mask .|. shiftMask	, xK_d		), spawn "urxvt -name jekyll-server.sh -e jekyll-server.sh -c '/usr/local/bin/jekyll-server.sh'")
	, ((controlMask .|. shiftMask	, xK_a		), spawn "audacity")
	, ((mod4Mask			, xK_p		), spawn myLauncher)
--	, ((0				, 0x1008FF11	), lowerVolume 3 >> return ())
--	, ((0				, 0x1008FF12	), toggleMute >> return ())
--	, ((0				, 0x1008FF13	), raiseVolume 3 >> return ())
	]
