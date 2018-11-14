--------------------------------------------------------------------------------
-- | Example.hs
--
-- Example configuration file for xmonad using the latest recommended
-- features (e.g., 'desktopConfig').
module Main (main) where

--------------------------------------------------------------------------------
import System.Exit
import XMonad
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
	, className =? "Chromium-browser"	--> doShift "2:web"
	, className =? "libreoffice-startcenter" --> doShift "3:writing"
	, className =? "FocusWriter"		--> doShift "3:writing"
	, className =? "Atom"			--> doShift "5:code"
	, title =? "jekyll-server"		--> doShift "9"
	, title =? "minicom"			--> doShift "6:serial"
	, isDialog				--> doCenterFloat
	] 

myWorkspaces = ["1:term","2:web","3:writing","4:music","5:code","6:serial"] ++ map show [7..9]

--------------------------------------------------------------------------------
main = do
xmproc <- spawnPipe "/usr/local/bin/xmobar /home/hbrenum/.xmobarrc"
xmonad $ defaultConfig
	{ startupHook		= do
		spawn "/usr/local/bin/xmobar /home/hbrenum/.xmobarrcbot"
		spawn "/home/hbrenum/bin/wallpaper.sh"
	, modMask		= mod4Mask
	, borderWidth		= 2
	, manageHook		= manageDocks <+> myManageHook <+> manageHook desktopConfig
	, layoutHook		= avoidStruts $ myLayout
	, handleEventHook	= handleEventHook defaultConfig <+> docksEventHook
	, logHook		= dynamicLogWithPP xmobarPP
		{ ppOutput	= hPutStrLn xmproc
		, ppTitle	= xmobarColor "#ff1493" "" . shorten 100
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
	, ((controlMask .|. shiftMask	, xK_m		), spawn "urxvt -name pianobar -e pianobar -c '/usr/bin/pianobar'")
	, ((controlMask .|. shiftMask	, xK_e		), spawn "urxvt -name minicom -e minicom -c '/usr/bin/minicom'")
	, ((mod4Mask .|. shiftMask	, xK_f		), spawn "urxvt -name vifm -e vifm -c '/usr/bin/vifm'")
	, ((0				, xK_Print	), spawn "scrot")
	, ((controlMask .|. shiftMask	, xK_w		), spawn "urxvt -name nano-wc -e nano-wc -c '/usr/local/bin/nano-wc'")
	, ((mod4Mask .|. shiftMask	, xK_b		), spawn "chromium-browser")
	, ((mod4Mask .|. shiftMask	, xK_l		), spawn "libreoffice")
	, ((controlMask .|. shiftMask	, xK_f		), spawn "focuswriter")
	, ((mod4Mask .|. shiftMask	, xK_a		), spawn "atom")
	, ((mod4Mask .|. shiftMask	, xK_d		), spawn "urxvt -name jekyll-server.sh -e jekyll-server.sh -c '/usr/local/bin/jekyll-server.sh'")
	]
