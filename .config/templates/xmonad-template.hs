-------------------------------------------------
-- Imports
-------------------------------------------------

-- Base

import XMonad
import System.Exit
import Data.Monoid
import System.IO
import System.Random (randomRIO)

-- Qualifieds (Tienen Alias)

import qualified XMonad.StackSet as W
import qualified XMonad.Layout.ToggleLayouts as T (toggleLayouts, ToggleLayout(Toggle))
import qualified XMonad.Layout.MultiToggle as MT (Toggle(..))
import qualified Data.Set as S 
import qualified Data.Map as M 

-- Utils

import XMonad.Util.SpawnOnce
import XMonad.Util.Run
import XMonad.Util.EZConfig
import XMonad.Util.Font
import XMonad.Util.NamedScratchpad

-- Hooks

import XMonad.Hooks.ManageDocks
import XMonad.Hooks.DynamicLog(dynamicLogWithPP, wrap, xmobarPP, xmobarColor, shorten, PP(..))
import XMonad.Hooks.EwmhDesktops
import XMonad.Hooks.ManageHelpers (isFullscreen, doFullFloat, doCenterFloat)
import XMonad.Hooks.FadeInactive
import XMonad.Hooks.SetWMName
import XMonad.Hooks.StatusBar.PP (filterOutWsPP)

-- Actions

import XMonad.Actions.MouseResize
import XMonad.Actions.GridSelect
import XMonad.Actions.Promote
import XMonad.Actions.RotSlaves
import XMonad.Actions.WithAll (sinkAll, killAll)
import XMonad.Actions.CopyWindow (kill1)
import XMonad.Actions.CycleWS (Direction1D(..), moveTo, shiftTo, WSType (..), nextScreen, prevScreen)

-- Data

import Data.Maybe (fromJust, isJust, fromMaybe)
import Data.Word (Word32)
import Data.IORef

-- Layouts

import XMonad.Layout.Renamed
import XMonad.Layout.NoBorders
import XMonad.Layout.WindowNavigation
import XMonad.Layout.WindowArranger
import XMonad.Layout.LimitWindows
import XMonad.Layout.Tabbed
import XMonad.Layout.Simplest
import XMonad.Layout.ResizableTile
import XMonad.Layout.SubLayouts
import XMonad.Layout.LayoutModifier
import XMonad.Layout.SimplestFloat
import XMonad.Layout.Spacing
import XMonad.Layout.ShowWName
import XMonad.Layout.ThreeColumns
import XMonad.Layout.Magnifier
import XMonad.Layout.Fullscreen
import XMonad.Layout.MultiToggle
import XMonad.Layout.GridVariants (Grid(Grid))
import XMonad.Layout.MultiToggle.Instances (StdTransformers (NBFULL, MIRROR, NOBORDERS))
import XMonad.Layout.WindowArranger (windowArrange, WindowArrangerMsg (..))

-- Control

import Control.Monad (liftM, join) 

-------------------------------------------------
-- Mi ColorScheme
-------------------------------------------------

-- Palenight

background :: String
background = BACKGROUND

foreground :: String
foreground = FOREGROUND

color0 :: String
color0 = COLOR0

color1 :: String
color1 = COLOR1

color2 :: String
color2 = COLOR2

color3 :: String
color3 = COLOR3

color4 :: String
color4 = COLOR4

color5 :: String
color5 = COLOR5

color6 :: String
color6 = COLOR6

color7 :: String
color7 = COLOR7

color8 :: String
color8 = COLOR8

color9 :: String
color9 = COLOR9

color10 :: String
color10 = COLOR10

color11 :: String
color11 = COLOR11

color12 :: String
color12 = COLOR12

color13 :: String
color13 = COLOR13

color14 :: String
color14 = COLOR14

color15 :: String
color15 = COLOR15

colorList :: [String]
colorList = [color0, color1, color2, 
             color3, color4, color5, 
             color6, color7, color8,
             color9, color10, color11,
             color12, color13, color14,
             color15, foreground, background]

-------------------------------------------------
-- Mi Configuración
-------------------------------------------------

myTerminal :: String
myTerminal = "alacritty"

myBrowser :: String
myBrowser = "qutebrowser"

mySearchEngine :: String
mySearchEngine = "https://search.brave.com"

myFont :: String
myFont = "xft:SauceCodePro Nerd Font Mono:regular:size=10:antialias=true:hinting=true"

myModMask :: KeyMask
myModMask = mod4Mask

myBorderWidth :: Dimension
myBorderWidth = 2

myIconDir :: String
myIconDir = "/home/kevin/.config/xmonad/icons/"

myConfigPath :: String
myConfigPath = "$HOME/.config/"

myScriptPath :: String
myScriptPath = myConfigPath ++ "scripts/"

myTabTheme = def
    { fontName              = myFont
    , activeColor           = color15 
    , inactiveColor         = color0 
    , activeBorderColor     = color4 
    , inactiveBorderColor   = color6 
    , activeTextColor       = color8 
    , inactiveTextColor     = color10 
    }

myColorizer :: a -> Bool -> X (String, String)
myColorizer _ isFg = do
    randomIndex <- io $ randomRIO (0, length colorList - 1)
    randomIndex2 <- io $ randomRIO (0, length colorList - 1)
    let chosenColor = colorList !! randomIndex
    let chosenColor2 = colorList !! randomIndex2
    if isFg 
	    then return (chosenColor, background) -- Color activo
	    else return (chosenColor2, background) -- Color inactivo

myConfig toggleFadeSet xmproc = ewmh def
    { manageHook                = myManageHook <+> manageDocks
    , modMask                   = myModMask
    , terminal                  = myTerminal
    , startupHook               = myStartupHook
    , layoutHook                = showWName' myShowWNameTheme $ myLayoutHook
    , workspaces                = myWorkspaces
    , borderWidth               = myBorderWidth
    , normalBorderColor         = color3
    , focusedBorderColor        = color7
    , logHook                   = myFadeHook toggleFadeSet <+> myLogHook xmproc
    } `additionalKeysP` myKeys toggleFadeSet


-------------------------------------------------
-- Mis Helpers 
-------------------------------------------------

split :: Eq a => a -> [a] -> [[a]]
split d [] = []
split d s = x : split d (drop 1 y) where (x,y) = span (/= d) s

extractName :: String -> String
extractName "" = ""
extractName s = spliteado !! 1
    where spliteado = split ':' s 

extractIndex :: String -> String 
extractIndex "" = ""
extractIndex s = spliteado !! 0
    where spliteado = split ':' s

getIcon :: String -> String
getIcon ws = "<icon=" ++ myIconDir ++ name ++  ".xpm/>"
    where name = extractName ws

getIconColor :: String -> String
getIconColor ws = "<icon=" ++ myIconDir ++ name ++ "-color.xpm/>"
    where name = extractName ws

clickable :: String -> String
clickable ws = "<action=xdotool key \"Super+" ++ show(index) ++ "\">" ++ getIcon ws ++ "</action>" 
    where index = extractIndex ws 

clickableColor :: String -> String
clickableColor ws = "<action=xdotool key \"Super+" ++ show(index) ++ "\">" ++ getIconColor ws ++ "</action>" 
    where index = extractIndex ws 

-------------------------------------------------
-- Mi StartupHook
-------------------------------------------------

myStartupHook :: X ()
myStartupHook = do
    spawnOnce "lxsession &"
    spawnOnce "picom --config $HOME/.config/picom/picom.conf &"
    spawnOnce "thunderbird &"
    spawnOnce "conky -c $HOME/.config/conky/hybrid/hybrid.conf &"
    spawnOnce "$HOME/.config/scripts/xmonadWallAndTheme.fish &"
    setWMName "Kevin"  


-------------------------------------------------
-- Mi Grid de Apps
-------------------------------------------------

myGridConfig :: p -> GSConfig Window
myGridConfig colorizer = (buildDefaultGSConfig myColorizer)
    { gs_cellheight     = 40
    , gs_cellwidth      = 200
    , gs_cellpadding    = 6
    , gs_originFractX   = 0.5
    , gs_originFractY   = 0.5
    , gs_font           = myFont 
    }

myGSConfig :: HasColorizer a => GSConfig a
myGSConfig = (buildDefaultGSConfig myColorizer)
    { gs_cellheight   = 40
    , gs_cellwidth    = 200
    , gs_cellpadding  = 6
    , gs_originFractX = 0.5
    , gs_originFractY = 0.5
    , gs_font         = myFont
    }


spawnSelected' :: [(String,String)] -> X ()
spawnSelected' lst = gridselect myGSConfig lst >>= flip whenJust spawn

myAppGrid =     [ ("Qutebrowser", "qutebrowser")
                , ("OBS", "obs")
                , ("Keys", "$HOME/.config/scripts/xmonad-keys.sh")
                , ("Aliases", "$HOME/.config/scripts/aliases.sh")
                , ("Joplin", "joplin-desktop")
                , ("Rambox", "rambox")
                , ("Bitwarden", "bitwarden-desktop")
                , ("Firefox", "firefox")
                , ("HTop", myTerminal ++ " -t HTop -e htop")
                , ("Steam", "steam")
                ]


-------------------------------------------------
-- Mis Hooks
-------------------------------------------------

myManageHook :: XMonad.Query (Data.Monoid.Endo WindowSet)
myManageHook = composeAll
    [ className             =? "confirm"                    --> doFloat
    , className             =? "file_progress"              --> doFloat
    , className             =? "dialog"                     --> doFloat
    , className             =? "download"                   --> doFloat
    , className             =? "error"                      --> doFloat
    , className             =? "Gimp"                       --> doFloat
    , className             =? "notification"               --> doFloat
    , className             =? "splash"                     --> doFloat
    , className             =? "toolbar"                    --> doFloat
    , className             =? "Conky"                      --> doFloat
    , className             =? "Yad"                        --> doCenterFloat 
    , className             =? "jetbrains-idea"          --> doCenterFloat 
    , className             =? "steam_app*"                 --> doCenterFloat 
    , (className =? "firefox" <&&> resource =? "Dialog")    --> doFloat
    , title                 =? "Mozilla Firefox"            --> doShift ( myWorkspaces !! 1 ) 
    , className             =? "qutebrowser"                --> unfloat 
    , className             =? "qutebrowser"                --> doShift ( myWorkspaces !! 1 ) 
    , className             =? "Kodi"                       --> doShift ( myWorkspaces !! 3 ) 
    , className             =? "Rambox"                     --> doShift ( myWorkspaces !! 4 ) 
    , className             =? "Ramboxpro"                  --> doShift ( myWorkspaces !! 4 ) 
    , className             =? "mpv"                        --> doShift ( myWorkspaces !! 5 ) 
    , className             =? "Bitwarden"                  --> doShift ( myWorkspaces !! 6 ) 
    , className             =? "Joplin"                     --> doShift ( myWorkspaces !! 7 ) 
    , className             =? "Thunderbird"                --> doShift ( myWorkspaces !! 7 ) 
    , className             =? "obs"                        --> doShift ( myWorkspaces !! 8 ) 
    , className             =? "openshot-qt"                --> doShift ( myWorkspaces !! 8 ) 
    , isFullscreen                                          --> doFullFloat
    ] <+> namedScratchpadManageHook myScratchPads
        where unfloat = ask >>= doF . W.sink

myFadeHook toogleFadeSet = fadeOutLogHook $ fadeIf (fadeCondition toogleFadeSet) 0.8
noFadeWindows = className =? "obs" <||> className =? "Rofi" <||> className =? "bitwarden" <||> className =? "alacritty" <||> className =? "qutebrowser"
 
fadeCondition :: IORef (S.Set Window) -> Query Bool
fadeCondition floats =
    liftM not noFadeWindows <&&> isUnfocused
    <&&> (join . asks $ \w -> liftX . io $ S.notMember w `fmap` readIORef floats)

toggleFadeOut :: Window -> S.Set Window -> S.Set Window
toggleFadeOut w s   | w `S.member` s    = S.delete w s
                    | otherwise         = S.insert w s

myLogHook :: Handle -> X ()
myLogHook x = dynamicLogWithPP $ filterOutWsPP [scratchpadWorkspaceTag] $ xmobarPP
    { ppOutput                      = hPutStrLn x
    , ppCurrent                     = xmobarColor color6 "" . wrap ("<box type=Bottom width=5 color="++ color6 ++">") "</box>" .getIconColor
    , ppVisible                     = xmobarColor color2 "" . wrap ("<box type=Bottom width=5 color="++ color2 ++">") "</box>" . clickableColor
    , ppHidden                      = xmobarColor color8 "" . wrap ("<box type=Bottom width=5 color="++ color8 ++">") "</box>" . clickable
    , ppHiddenNoWindows             = xmobarColor color1 "" . wrap ("<box type=Bottom width=5 color="++ color1 ++">") "</box>" .clickable
    , ppUrgent                      = xmobarColor color15 "" . wrap "!" "!" . clickable
    , ppTitle                       = xmobarColor color15 "" . shorten 60 
    , ppSep                         = "<fc="++ color7 ++"> <fn=1>|</fn> </fc>" 
    , ppExtras                      = [windowCount] 
    , ppOrder                       = \(ws:l:t:ex) -> [ws,l]++ex++[t] 
    }


-------------------------------------------------
-- Mis Workspaces
-------------------------------------------------

myWorkspaces = ["1:Desarrollo", "2:Navegar", "3:Entretenimiento", "4:Video", "5:Comunicacion", "6:SoloAudio", "7:Passwords", "8:Notas", "9:Stream"]
myWorkspacesIndices = M.fromList $ zipWith (,) myWorkspaces [1..] 


windowCount :: X (Maybe String)
windowCount = gets $ Just . show . length . W.integrate' . W.stack . W.workspace . W.current . windowset

myShowWNameTheme :: SWNConfig
myShowWNameTheme    = def
    { swn_font      = "xft:Hack Nerd Font Mono:bold:size=40"
    , swn_fade      = 1.0
    , swn_bgcolor   = color0 
    , swn_color     = color15
    }

-------------------------------------------------
-- Mis ScratchPads 
-------------------------------------------------

myScratchPads :: [NamedScratchpad]
myScratchPads = [ NS "terminal" spawnTerm findTerm manageTerm
                , NS "spt" spawnSpt findSpt manageSpt 
                , NS "telegram" spawnTelegram findTelegram manageTelegram 
                , NS "htop" spawnHtop findHtop manageHtop 
                ]
    where
        spawnTerm                   = myTerminal ++ " -t scratchpad"
        findTerm                    = title =? "scratchpad"
        manageTerm                  = customFloating $ W.RationalRect l t w h
            where
                h = 0.9
                w = 0.9
                t = 0.95 -h
                l = 0.95 -w
        spawnSpt                    = myTerminal ++ " -t Spotify -e spt"
        findSpt                     = title =? "Spotify"
        manageSpt                   = customFloating $ W.RationalRect l t w h
            where
                h = 0.9
                w = 0.9
                t = 0.95 -h
                l = 0.95 -w
        spawnTelegram               = "telegram-desktop"
        findTelegram                = title =? "Telegram"
        manageTelegram              = customFloating $ W.RationalRect l t w h
            where
                h = 0.9
                w = 0.9
                t = 0.95 -h
                l = 0.95 -w
        spawnHtop                   = myTerminal ++ " -t HTop -e htop "
        findHtop                    = title =? "HTop"
        manageHtop                  = customFloating $ W.RationalRect l t w h
            where
                h = 0.9
                w = 0.9
                t = 0.95 -h
                l = 0.95 -w

-------------------------------------------------
-- My Layouts
-------------------------------------------------
myLayoutHook = avoidStruts $ mouseResize $ windowArrange $ T.toggleLayouts floats 
    $ mkToggle (NBFULL ?? NOBORDERS ?? EOT) myDefaultLayout
        where myDefaultLayout = withBorder myBorderWidth tall
                ||| withBorder myBorderWidth magnifym
                ||| floats 
                ||| withBorder myBorderWidth grid 
                ||| noBorders tabs 
                ||| withBorder myBorderWidth threeCol 
                ||| withBorder myBorderWidth threeRow 


mySpacing :: Integer -> l a -> XMonad.Layout.LayoutModifier.ModifiedLayout Spacing l a
mySpacing i = spacingRaw False (Border i i i i) True (Border i i i i) True

tall            = renamed [Replace "tall"]
                $ smartBorders
                $ windowNavigation
                $ addTabs shrinkText myTabTheme 
                $ subLayout [] (smartBorders Simplest) 
                $ limitWindows 12 
                $ mySpacing 8 
                $ ResizableTall 1 (3/100) (1/2) [] 
magnifym        = renamed [Replace "magnify"]
                $ smartBorders
                $ windowNavigation
                $ addTabs shrinkText myTabTheme 
                $ subLayout [] (smartBorders Simplest) 
                $ magnifier
                $ limitWindows 12 
                $ mySpacing 8 
                $ ResizableTall 1 (3/100) (1/2) [] 
grid            = renamed [Replace "grid"]
                $ smartBorders
                $ windowNavigation
                $ addTabs shrinkText myTabTheme 
                $ subLayout [] (smartBorders Simplest) 
                $ magnifier
                $ limitWindows 12 
                $ mySpacing 8 
                $ mkToggle (single MIRROR)
                $ Grid (16/10)
floats          = renamed [Replace "floats"]
                $ smartBorders
                $ limitWindows 20 simplestFloat 
tabs            = renamed [Replace "tabs"]
                $ mySpacing 8
                $ tabbed shrinkText myTabTheme
threeCol        = renamed [Replace "threeCol"]
                $ smartBorders
                $ windowNavigation
                $ addTabs shrinkText myTabTheme 
                $ subLayout [] (smartBorders Simplest) 
                $ limitWindows 7 
                $ mySpacing 8 
                $ ThreeCol 1 (3/100) (1/2)
threeRow        = renamed [Replace "threeRow"]
                $ smartBorders
                $ windowNavigation
                $ addTabs shrinkText myTabTheme 
                $ subLayout [] (smartBorders Simplest) 
                $ limitWindows 7 
                $ Mirror
                $ ThreeCol 1 (3/100) (1/2)


-------------------------------------------------
-- My Keys 
-------------------------------------------------

myKeys toggleFadeSet =
    -- KEY_GROUP XMonad
    [ ("M-C-r", spawn "xmonad --recompile")                                         -- Recompilar XMonad
    , ("M-S-r", spawn "xmonad --restart")                                           -- Resetear XMonad
    , ("M-S-q", io exitSuccess)                                                     -- Salir de XMonad
    , ("M-S-h", spawn "$HOME/.config/xmonad/xmonad-keys.sh")                               -- Mostrar Ayuda 
    , ("M-S-a", spawn "$HOME/.config/xmonad/aliases.sh")                                   -- Mostrar Ayuda 

    -- KEY_GROUP Utils
    , ("M-<Return>", spawn (myTerminal))                                            -- Abrir Terminal
    , ("M-b", spawn (myBrowser))                                                    -- Abrir Browser
    , ("M-M1-h", spawn (myTerminal ++ " -e htop"))                                  -- Abrir HTOP
    , ("M-<F1>", spawn "~/.config/scripts/xmonadWallAndTheme.fish")                 -- Cambiar Wallpaper
    , ("M-S-f", withFocused $ io . modifyIORef toggleFadeSet . toggleFadeOut)       -- Toggle transparencia
    , ("<Print>", spawn "flameshot gui")                                            -- Screenshot


    -- KEY_GROUP dmenu
    , ("M-S-<Return>", spawn "rofi -show run -config ~/.config/rofi/themes/km-dmenu.rasi -display-run Run: ")                           -- Mostrar DMenu

    -- KEY_GROUP Kills
    , ("M-S-c", kill1)                                                              -- Kill Ventana
    , ("M-S-d", killAll)                                                            -- Kill todo el Workspace

    -- KEY_GROUP Workspaces
    , ("M-.", nextScreen)                                                           -- Workspace siguiente
    , ("M-,", prevScreen)                                                           -- Workspace anterior
    
    -- KEY_GROUP Float Window
    , ("M-f", sendMessage (T.Toggle "floats"))                                      -- Convertir a Float 
    , ("M-t", withFocused $ windows . W.sink)                                       -- No se Aun 
    , ("M-S-t", sinkAll)                                                            -- No se Aun

    -- KEY_GROUP Increase/Decrease spacing
    , ("C-M1-j", decWindowSpacing 4)                                                -- Reducir margen intraventana
    , ("C-M1-k", incWindowSpacing 4)                                                -- Aumentar margen intraventana
    , ("C-M1-h", incScreenSpacing 4)                                                -- Aumentar margen Pantalla
    , ("C-M1-l", decScreenSpacing 4)                                                -- Reducir margen Pantalla

    -- KEY_GROUP Grid
    , ("C-g g", spawnSelected' myAppGrid)                                           -- Mostrar Grid de Apps
    , ("C-g t", goToSelected $ myGridConfig myColorizer)                            -- Mostrar Apps e ir
    , ("C-g b", bringSelected $ myGridConfig myColorizer)                           -- Mostrar Apps y traer

    -- KEY_GROUP ScratchPads
    , ("C-s t", namedScratchpadAction myScratchPads "terminal")                     -- Scratchpad Terminal
    , ("C-s m", namedScratchpadAction myScratchPads "spt")                          -- Scratchpad Spotify
    , ("C-s h", namedScratchpadAction myScratchPads "telegram")                     -- Scratchpad Telegram
    , ("C-s n", namedScratchpadAction myScratchPads "htop")                         -- Scratchpad HTop 

    -- KEY_GROUP Windows Navigation
    , ("M-m", windows W.focusMaster)                                                -- Focusear ventana Master
    , ("M-j", windows W.focusDown)                                                  -- Focusear ventana inferior
    , ("M-k", windows W.focusUp)                                                    -- Focusear ventana superior
    , ("M-S-m", windows W.swapMaster)                                               -- Switchear ventana con Master
    , ("M-S-j", windows W.swapDown)                                                 -- Bajar ventana de posicion
    , ("M-S-k", windows W.swapUp)                                                   -- Subir ventana de posicion
    , ("M-<Backspace>", promote)                                                    -- Promover a Master (Master baja)
    , ("M-S-<Tab>", rotSlavesDown)                                                  -- Bajar ventana (Solo no Master)
    , ("M-C-<Tab>", rotSlavesUp)                                                    -- Subir ventana (Solo no Master)

    -- KEY_GROUP Windows Resizing
    , ("M-h", sendMessage Shrink)                                                   -- Achicar Master
    , ("M-l", sendMessage Expand)                                                   -- Expandir Master
    , ("M-M1-j", sendMessage MirrorShrink)                                          -- Achicar Vertical (Not work?)
    , ("M-M1-k", sendMessage MirrorExpand)                                          -- Expandir Vertical (Not work?)

    -- KEY_GROUP Layout
    , ("M-<Tab>", sendMessage NextLayout)                                           -- Cambiar Layout
    , ("M-<Space>", sendMessage (MT.Toggle NBFULL) >> sendMessage ToggleStruts)     -- Quitar margenes

    -- KEY_GROUP Sublayouts (Tabbear)
    , ("M-C-h", sendMessage $ pullGroup L)                                          -- Agrupar con ventana izquierda
    , ("M-C-l", sendMessage $ pullGroup R)                                          -- Agrupar con ventana derecha
    , ("M-C-k", sendMessage $ pullGroup U)                                          -- Agrupar con ventana arriba
    , ("M-C-j", sendMessage $ pullGroup D)                                          -- Agrupar con ventana abajo
    , ("M-C-m", withFocused (sendMessage . MergeAll))                               -- Agrupar todo el Workspace
    , ("M-C-n", withFocused (sendMessage . UnMergeAll))                             -- Desagrupar el Workspace
    , ("M-C-<Left>", onGroup W.focusUp')                                            -- Moverse a la Tab izquierda
    , ("M-C-<Right>", onGroup W.focusDown')                                         -- Moverse a la Tab derecha
    
    -- KEY_GROUP Multimedia Keys (fn)
    , ("<XF86AudioMute>", spawn (myScriptPath ++ "volume-brightness.sh volume_mute"))       -- Mutear Audio
    , ("<XF86AudioLowerVolume>", spawn (myScriptPath ++ "volume-brightness.sh volume_down"))    -- Bajar Volumen
    , ("<XF86AudioRaiseVolume>", spawn (myScriptPath ++ "volume-brightness.sh volume_up"))    -- Subir Volumen
    , ("<XF86MonBrightnessUp>", spawn (myScriptPath ++ "volume-brightness.sh brightness_up"))                         -- Subir Brillo
    , ("<XF86MonBrightnessDown>", spawn (myScriptPath ++ "volume-brightness.sh brightness_down"))                       -- Bajar Brillo
    , ("<XF86Search>", spawn "rofi -show drun -config km-icons.rasi -display-drun Run: ")             -- Rofi buscador

    -- KEY_GROUP Extras
    , ("M-<End>", spawn (myScriptPath ++ "volume-brightness.sh next_track"))             -- Cancion siguiente
    , ("M-<Home>", spawn (myScriptPath ++ "volume-brightness.sh prev_track"))             -- Cancion siguiente
    , ("M-C-<Space>", spawn (myScriptPath ++ "volume-brightness.sh play_pause"))             -- Cancion siguiente
    ]

-------------------------------------------------
-- My Main 
-------------------------------------------------

main = do
    xmproc <- spawnPipe "xmobar -x 0 $HOME/.config/xmobar/xmobarrc"
    toggleFadeSet <- newIORef S.empty
    xmonad $ myConfig toggleFadeSet xmproc
