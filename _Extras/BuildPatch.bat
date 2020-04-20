@echo off
cd /D "%~dp0"
set modname=%~1
set modversion=%~2
set /P version=<"%cd%\Tools\version.txt"

echo.
echo WrathEd %version%
echo.

:modname
if not defined modname set /P modname="Mod Name: "
if not defined modname goto modname
:modversion
if not defined modversion set /P modversion="Mod Version: "
if not defined modversion goto modversion
set streamversion=_mod

for /F "tokens=2* delims=	 " %%A in ('REG QUERY "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\User Shell Folders" /v "Personal"') do call set mydocs=%%B
for /F "tokens=2* delims=	 " %%A in ('REG QUERY "HKLM\Software\Electronic Arts\Electronic Arts\Command and Conquer 3 Kanes Wrath" /v "UserDataLeafName" 2^>nul') do call set userdataleaf="%%B"
if not defined userdataleaf for /F "tokens=2* delims=	 " %%A in ('REG QUERY "HKLM\Software\Wow6432Node\Electronic Arts\Electronic Arts\Command and Conquer 3 Kanes Wrath" /v "UserDataLeafName" 2^>nul') do call set userdataleaf="%%B"

if not defined userdataleaf (
	set userdataleaf="Command and Conquer 3 Kanes Wrath"
)

for /F "delims=" %%A in (%userdataleaf%) do set userdataleaf=%%~A

echo.
echo %modname% %modversion%

if not exist "%cd%\Mods\%modname%" (
	echo Error: The mod doesn't exist
	echo.
	pause
	goto eof
)

if exist "%cd%\Compilation\Mods\%modname%" rd "%cd%\Compilation\Mods\%modname%" /S /Q

echo Compiling Mod...

if exist "%cd%\Mods\%modname%\Data\AdditionalMaps\MapMetaData_Global.xml" "%cd%\Tools\WrathEd.exe" -gameDefinition:"Kane's Wrath" -compile:"%cd%\Mods\%modname%\Data\AdditionalMaps\MapMetaData_Global.xml" -art:"..\..\Art" -audio:"..\..\Audio" -out:"%cd%\Compilation\Mods\%modname%\Data\AdditionalMaps" -version:""

if exist "%cd%\Mods\%modname%\Data\AdditionalMaps\MapMetaData_GlobalOverrides.xml" "%cd%\Tools\WrathEd.exe" -gameDefinition:"Kane's Wrath" -compile:"%cd%\Mods\%modname%\Data\AdditionalMaps\MapMetaData_GlobalOverrides.xml" -art:"..\..\Art" -audio:"..\..\Audio" -out:"%cd%\Compilation\Mods\%modname%\Data\AdditionalMaps" -version:""

if exist "%cd%\Mods\%modname%\Data\Global.xml" "%cd%\Tools\WrathEd.exe" -gameDefinition:"Kane's Wrath" -compile:"%cd%\Mods\%modname%\Data\Global.xml" -art:"..\Art" -audio:"..\Audio" -out:"%cd%\Compilation\Mods\%modname%\Data" -version:"%streamversion%" -bps:"global_common_2.manifest,%cd%\Game Files\Manifest\global_common_2.manifest"

if exist "%cd%\Mods\%modname%\Data\Static.xml" (
	"%cd%\Tools\WrathEd.exe" -gameDefinition:"Kane's Wrath" -compile:"%cd%\Mods\%modname%\Data\Static.xml" -art:"..\Art" -audio:"..\Audio" -out:"%cd%\Compilation\Mods\%modname%\Data" -version:"%streamversion%" -bps:"static_common_2.manifest,%cd%\Game Files\Manifest\static_common_2.manifest"

	"%cd%\Tools\WrathEd.exe" -gameDefinition:"Kane's Wrath" -compile:"%cd%\Mods\%modname%\Data\Static.xml" -art:"..\Art_L" -audio:"..\Audio" -out:"%cd%\Compilation\Mods\%modname%\Data" -version:"_l%streamversion%" -bcn:LowLOD -bps:"static_l_common_2.manifest,%cd%\Game Files\Manifest\static_l_common_2.manifest"

	if exist "%cd%\Compilation\Mods\%modname%\Data\Static.version" del "%cd%\Compilation\Mods\%modname%\Data\Static.version"
	if exist "%cd%\Compilation\Mods\%modname%\Data\Static_l.version" del "%cd%\Compilation\Mods\%modname%\Data\Static_l.version"
	echo _mod>> "%cd%\Compilation\Mods\%modname%\Data\Static.version"
	echo _mod>> "%cd%\Compilation\Mods\%modname%\Data\Static_l.version"
)

if exist "%cd%\Mods\%modname%\Data\Worldbuilder.xml" "%cd%\Tools\WrathEd.exe" -gameDefinition:"Kane's Wrath" -compile:"%cd%\Mods\%modname%\Data\Worldbuilder.xml" -art:"..\Art" -audio:"..\Audio" -out:"%cd%\Compilation\Mods\%modname%\Data" -version:"%streamversion%" -bps:"worldbuilder_2.manifest,%cd%\Game Files\Manifest\worldbuilder_2.manifest"

if exist "%cd%\Mods\%modname%\Data\MapMetaData.xml" "%cd%\Tools\WrathEd.exe" -gameDefinition:"Kane's Wrath" -compile:"%cd%\Mods\%modname%\Data\MapMetaData.xml" -art:"..\Art" -audio:"..\Audio" -out:"%cd%\Compilation\Mods\%modname%\Data" -version:"%streamversion%" -bps:"mapmetadata.manifest,%cd%\Game Files\Manifest\mapmetadata.manifest"

if exist "%cd%\Mods\%modname%\Data\MetaGame.xml" "%cd%\Tools\WrathEd.exe" -gameDefinition:"Kane's Wrath" -compile:"%cd%\Mods\%modname%\Data\MetaGame.xml" -art:"..\Art" -audio:"..\Audio" -out:"%cd%\Compilation\Mods\%modname%\Data" -version:"%streamversion%" -bps:"metagame.manifest,%cd%\Game Files\Manifest\metagame.manifest"

setlocal EnableDelayedExpansion

set sdk=!cd!
cd /D "!sdk!\Game Files\Manifest\AptUI"

for %%A in ("*.manifest") do (
	if exist "!sdk!\Mods\%modname%\Data\AptUI\%%~nA.xml" "!sdk!\Tools\WrathEd.exe" -gameDefinition:"Kane's Wrath" -compile:"!sdk!\Mods\%modname%\Data\AptUI\%%~nA.xml" -art:"..\..\Art" -audio:"..\..\Audio" -out:"!sdk!\Compilation\Mods\%modname%\Data\AptUI" -bps:"aptui\%%~nA.manifest,!sdk!\Game Files\Manifest\AptUI\%%~nA.manifest" -version:"%streamversion%"
)

cd /D "!sdk!"
set sdk=

endlocal EnableDelayedExpansion

if exist "%cd%\Compilation\Mods\%modname%" "%cd%\Tools\MakeBig.exe" -f "%cd%\Compilation\Mods\%modname%" -o:"%mydocs%\%userdataleaf%\Mods\%modname%\Core\%modname%_%modversion%_Streams.big"
if exist "%cd%\Mods\%modname%\Misc" "%cd%\Tools\MakeBig.exe" -f "%cd%\Mods\%modname%\Misc" -o:"%mydocs%\%userdataleaf%\Mods\%modname%\Core\%modname%_%modversion%_Misc.big"

echo Compiling Maps...

if exist "%cd%\Compilation\Mods\%modname%" rd "%cd%\Compilation\Mods\%modname%" /S /Q

if exist "%cd%\Mods\%modname%\Data\maps\official\CM_1_1_Rio_Insurrection\map.xml" "%cd%\Tools\WrathEd.exe" -gameDefinition:"Kane's Wrath" -compile:"%cd%\Mods\%modname%\Data\maps\official\CM_1_1_Rio_Insurrection\map.xml" -data:"..\..\..\..\Data" -art:"..\..\..\..\Art" -audio:"..\..\..\..\Audio" -out:"%cd%\Compilation\Mods\%modname%\Data\maps\official\CM_1_1_Rio_Insurrection" -version:"%streamversion%" -bps:"maps\official\cm_1_1_rio_insurrection\map_2.manifest,%cd%\Game Files\Manifest\maps\official\CM_1_1_Rio_Insurrection\map_2.manifest"
if exist "%cd%\Mods\%modname%\Data\maps\official\CM_1_1_Rio_Insurrection\CM_1_1_Rio_Insurrection.map" copy "%cd%\Mods\%modname%\Data\maps\official\CM_1_1_Rio_Insurrection\CM_1_1_Rio_Insurrection.map" "%cd%\Compilation\Mods\%modname%\Data\maps\official\CM_1_1_Rio_Insurrection"

if exist "%cd%\Mods\%modname%\Data\maps\official\CM_1_2_Steel_Talons\map.xml" "%cd%\Tools\WrathEd.exe" -gameDefinition:"Kane's Wrath" -compile:"%cd%\Mods\%modname%\Data\maps\official\CM_1_2_Steel_Talons\map.xml" -data:"..\..\..\..\Data" -art:"..\..\..\..\Art" -audio:"..\..\..\..\Audio" -out:"%cd%\Compilation\Mods\%modname%\Data\maps\official\CM_1_2_Steel_Talons" -version:"%streamversion%" -bps:"maps\official\cm_1_2_steel_talons\map_2.manifest,%cd%\Game Files\Manifest\maps\official\CM_1_2_Steel_Talons\map_2.manifest"
if exist "%cd%\Mods\%modname%\Data\maps\official\CM_1_2_Steel_Talons\CM_1_2_Steel_Talons.map" copy "%cd%\Mods\%modname%\Data\maps\official\CM_1_2_Steel_Talons\CM_1_2_Steel_Talons.map" "%cd%\Compilation\Mods\%modname%\Data\maps\official\CM_1_2_Steel_Talons"

if exist "%cd%\Mods\%modname%\Data\maps\official\CM_1_3_Brother_Marcion\map.xml" "%cd%\Tools\WrathEd.exe" -gameDefinition:"Kane's Wrath" -compile:"%cd%\Mods\%modname%\Data\maps\official\CM_1_3_Brother_Marcion\map.xml" -data:"..\..\..\..\Data" -art:"..\..\..\..\Art" -audio:"..\..\..\..\Audio" -out:"%cd%\Compilation\Mods\%modname%\Data\maps\official\CM_1_3_Brother_Marcion" -version:"%streamversion%" -bps:"maps\official\cm_1_3_brother_marcion\map_2.manifest,%cd%\Game Files\Manifest\maps\official\CM_1_3_Brother_Marcion\map_2.manifest"
if exist "%cd%\Mods\%modname%\Data\maps\official\CM_1_3_Brother_Marcion\CM_1_3_Brother_Marcion.map" copy "%cd%\Mods\%modname%\Data\maps\official\CM_1_3_Brother_Marcion\CM_1_3_Brother_Marcion.map" "%cd%\Compilation\Mods\%modname%\Data\maps\official\CM_1_3_Brother_Marcion"

if exist "%cd%\Mods\%modname%\Data\maps\official\CM_1_4_Tib_Research\map.xml" "%cd%\Tools\WrathEd.exe" -gameDefinition:"Kane's Wrath" -compile:"%cd%\Mods\%modname%\Data\maps\official\CM_1_4_Tib_Research\map.xml" -data:"..\..\..\..\Data" -art:"..\..\..\..\Art" -audio:"..\..\..\..\Audio" -out:"%cd%\Compilation\Mods\%modname%\Data\maps\official\CM_1_4_Tib_Research" -version:"%streamversion%" -bps:"maps\official\cm_1_4_tib_research\map_2.manifest,%cd%\Game Files\Manifest\maps\official\CM_1_4_Tib_Research\map_2.manifest"
if exist "%cd%\Mods\%modname%\Data\maps\official\CM_1_4_Tib_Research\CM_1_4_Tib_Research.map" copy "%cd%\Mods\%modname%\Data\maps\official\CM_1_4_Tib_Research\CM_1_4_Tib_Research.map" "%cd%\Compilation\Mods\%modname%\Data\maps\official\CM_1_4_Tib_Research"

if exist "%cd%\Mods\%modname%\Data\maps\official\CM_2_1_Capture_Tech\map.xml" "%cd%\Tools\WrathEd.exe" -gameDefinition:"Kane's Wrath" -compile:"%cd%\Mods\%modname%\Data\maps\official\CM_2_1_Capture_Tech\map.xml" -data:"..\..\..\..\Data" -art:"..\..\..\..\Art" -audio:"..\..\..\..\Audio" -out:"%cd%\Compilation\Mods\%modname%\Data\maps\official\CM_2_1_Capture_Tech" -version:"%streamversion%" -bps:"maps\official\cm_2_1_capture_tech\map.manifest,%cd%\Game Files\Manifest\maps\official\CM_2_1_Capture_Tech\map.manifest"
if exist "%cd%\Mods\%modname%\Data\maps\official\CM_2_1_Capture_Tech\CM_2_1_Capture_Tech.map" copy "%cd%\Mods\%modname%\Data\maps\official\CM_2_1_Capture_Tech\CM_2_1_Capture_Tech.map" "%cd%\Compilation\Mods\%modname%\Data\maps\official\CM_2_1_Capture_Tech"

if exist "%cd%\Mods\%modname%\Data\maps\official\CM_2_2_Treasury_Raid\map.xml" "%cd%\Tools\WrathEd.exe" -gameDefinition:"Kane's Wrath" -compile:"%cd%\Mods\%modname%\Data\maps\official\CM_2_2_Treasury_Raid\map.xml" -data:"..\..\..\..\Data" -art:"..\..\..\..\Art" -audio:"..\..\..\..\Audio" -out:"%cd%\Compilation\Mods\%modname%\Data\maps\official\CM_2_2_Treasury_Raid" -version:"%streamversion%" -bps:"maps\official\cm_2_2_treasury_raid\map_2.manifest,%cd%\Game Files\Manifest\maps\official\CM_2_2_Treasury_Raid\map_2.manifest"
if exist "%cd%\Mods\%modname%\Data\maps\official\CM_2_2_Treasury_Raid\CM_2_2_Treasury_Raid.map" copy "%cd%\Mods\%modname%\Data\maps\official\CM_2_2_Treasury_Raid\CM_2_2_Treasury_Raid.map" "%cd%\Compilation\Mods\%modname%\Data\maps\official\CM_2_2_Treasury_Raid"

if exist "%cd%\Mods\%modname%\Data\maps\official\CM_2_3_Capture_Giraud\map.xml" "%cd%\Tools\WrathEd.exe" -gameDefinition:"Kane's Wrath" -compile:"%cd%\Mods\%modname%\Data\maps\official\CM_2_3_Capture_Giraud\map.xml" -data:"..\..\..\..\Data" -art:"..\..\..\..\Art" -audio:"..\..\..\..\Audio" -out:"%cd%\Compilation\Mods\%modname%\Data\maps\official\CM_2_3_Capture_Giraud" -version:"%streamversion%" -bps:"maps\official\cm_2_3_capture_giraud\map_2.manifest,%cd%\Game Files\Manifest\maps\official\CM_2_3_Capture_Giraud\map_2.manifest"
if exist "%cd%\Mods\%modname%\Data\maps\official\CM_2_3_Capture_Giraud\CM_2_3_Capture_Giraud.map" copy "%cd%\Mods\%modname%\Data\maps\official\CM_2_3_Capture_Giraud\CM_2_3_Capture_Giraud.map" "%cd%\Compilation\Mods\%modname%\Data\maps\official\CM_2_3_Capture_Giraud"

if exist "%cd%\Mods\%modname%\Data\maps\official\CM_2_4_MARV\map.xml" "%cd%\Tools\WrathEd.exe" -gameDefinition:"Kane's Wrath" -compile:"%cd%\Mods\%modname%\Data\maps\official\CM_2_4_MARV\map.xml" -data:"..\..\..\..\Data" -art:"..\..\..\..\Art" -audio:"..\..\..\..\Audio" -out:"%cd%\Compilation\Mods\%modname%\Data\maps\official\CM_2_4_MARV" -version:"%streamversion%" -bps:"maps\official\cm_2_4_marv\map_2.manifest,%cd%\Game Files\Manifest\maps\official\CM_2_4_MARV\map_2.manifest"
if exist "%cd%\Mods\%modname%\Data\maps\official\CM_2_4_MARV\CM_2_4_MARV.map" copy "%cd%\Mods\%modname%\Data\maps\official\CM_2_4_MARV\CM_2_4_MARV.map" "%cd%\Compilation\Mods\%modname%\Data\maps\official\CM_2_4_MARV"

if exist "%cd%\Mods\%modname%\Data\maps\official\CM_2_5_Temple_Prime\map.xml" "%cd%\Tools\WrathEd.exe" -gameDefinition:"Kane's Wrath" -compile:"%cd%\Mods\%modname%\Data\maps\official\CM_2_5_Temple_Prime\map.xml" -data:"..\..\..\..\Data" -art:"..\..\..\..\Art" -audio:"..\..\..\..\Audio" -out:"%cd%\Compilation\Mods\%modname%\Data\maps\official\CM_2_5_Temple_Prime" -version:"%streamversion%" -bps:"maps\official\cm_2_5_temple_prime\map_2.manifest,%cd%\Game Files\Manifest\maps\official\CM_2_5_Temple_Prime\map_2.manifest"
if exist "%cd%\Mods\%modname%\Data\maps\official\CM_2_5_Temple_Prime\CM_2_5_Temple_Prime.map" copy "%cd%\Mods\%modname%\Data\maps\official\CM_2_5_Temple_Prime\CM_2_5_Temple_Prime.map" "%cd%\Compilation\Mods\%modname%\Data\maps\official\CM_2_5_Temple_Prime"

if exist "%cd%\Mods\%modname%\Data\maps\official\CM_2_6_Traveler59\map.xml" "%cd%\Tools\WrathEd.exe" -gameDefinition:"Kane's Wrath" -compile:"%cd%\Mods\%modname%\Data\maps\official\CM_2_6_Traveler59\map.xml" -data:"..\..\..\..\Data" -art:"..\..\..\..\Art" -audio:"..\..\..\..\Audio" -out:"%cd%\Compilation\Mods\%modname%\Data\maps\official\CM_2_6_Traveler59" -version:"%streamversion%" -bps:"maps\official\cm_2_6_traveler59\map_2.manifest,%cd%\Game Files\Manifest\maps\official\CM_2_6_Traveler59\map_2.manifest"
if exist "%cd%\Mods\%modname%\Data\maps\official\CM_2_6_Traveler59\CM_2_6_Traveler59.map" copy "%cd%\Mods\%modname%\Data\maps\official\CM_2_6_Traveler59\CM_2_6_Traveler59.map" "%cd%\Compilation\Mods\%modname%\Data\maps\official\CM_2_6_Traveler59"

if exist "%cd%\Mods\%modname%\Data\maps\official\CM_2_7_Tacitus_A\map.xml" "%cd%\Tools\WrathEd.exe" -gameDefinition:"Kane's Wrath" -compile:"%cd%\Mods\%modname%\Data\maps\official\CM_2_7_Tacitus_A\map.xml" -data:"..\..\..\..\Data" -art:"..\..\..\..\Art" -audio:"..\..\..\..\Audio" -out:"%cd%\Compilation\Mods\%modname%\Data\maps\official\CM_2_7_Tacitus_A" -version:"%streamversion%" -bps:"maps\official\cm_2_7_tacitus_a\map_2.manifest,%cd%\Game Files\Manifest\maps\official\CM_2_7_Tacitus_A\map_2.manifest"
if exist "%cd%\Mods\%modname%\Data\maps\official\CM_2_7_Tacitus_A\CM_2_7_Tacitus_A.map" copy "%cd%\Mods\%modname%\Data\maps\official\CM_2_7_Tacitus_A\CM_2_7_Tacitus_A.map" "%cd%\Compilation\Mods\%modname%\Data\maps\official\CM_2_7_Tacitus_A"

if exist "%cd%\Mods\%modname%\Data\maps\official\CM_3_1_Marked_Of_Kane\map.xml" "%cd%\Tools\WrathEd.exe" -gameDefinition:"Kane's Wrath" -compile:"%cd%\Mods\%modname%\Data\maps\official\CM_3_1_Marked_Of_Kane\map.xml" -data:"..\..\..\..\Data" -art:"..\..\..\..\Art" -audio:"..\..\..\..\Audio" -out:"%cd%\Compilation\Mods\%modname%\Data\maps\official\CM_3_1_Marked_Of_Kane" -version:"%streamversion%" -bps:"maps\official\cm_3_1_marked_of_kane\map_2.manifest,%cd%\Game Files\Manifest\maps\official\CM_3_1_Marked_Of_Kane\map_2.manifest"
if exist "%cd%\Mods\%modname%\Data\maps\official\CM_3_1_Marked_Of_Kane\CM_3_1_Marked_Of_Kane.map" copy "%cd%\Mods\%modname%\Data\maps\official\CM_3_1_Marked_Of_Kane\CM_3_1_Marked_Of_Kane.map" "%cd%\Compilation\Mods\%modname%\Data\maps\official\CM_3_1_Marked_Of_Kane"

if exist "%cd%\Mods\%modname%\Data\maps\official\CM_3_2_Tacitus_B\map.xml" "%cd%\Tools\WrathEd.exe" -gameDefinition:"Kane's Wrath" -compile:"%cd%\Mods\%modname%\Data\maps\official\CM_3_2_Tacitus_B\map.xml" -data:"..\..\..\..\Data" -art:"..\..\..\..\Art" -audio:"..\..\..\..\Audio" -out:"%cd%\Compilation\Mods\%modname%\Data\maps\official\CM_3_2_Tacitus_B" -version:"%streamversion%" -bps:"maps\official\cm_3_2_tacitus_b\map_2.manifest,%cd%\Game Files\Manifest\maps\official\CM_3_2_Tacitus_B\map_2.manifest"
if exist "%cd%\Mods\%modname%\Data\maps\official\CM_3_2_Tacitus_B\CM_3_2_Tacitus_B.map" copy "%cd%\Mods\%modname%\Data\maps\official\CM_3_2_Tacitus_B\CM_3_2_Tacitus_B.map" "%cd%\Compilation\Mods\%modname%\Data\maps\official\CM_3_2_Tacitus_B"

if exist "%cd%\Compilation\Mods\%modname%" "%cd%\Tools\MakeBig.exe" -f "%cd%\Compilation\Mods\%modname%" -o:"%mydocs%\%userdataleaf%\Mods\%modname%\Meta\%modname%_%modversion%_Maps.big"

if exist "%mydocs%\%userdataleaf%\Mods\%modname%\%modname%_%modversion%.skudef" del "%mydocs%\%userdataleaf%\Mods\%modname%\%modname%_%modversion%.skudef" /F /Q
if exist "%mydocs%\%userdataleaf%\Mods\%modname%\Core\%modname%_%modversion%_Streams.big" echo add-big Core\%modname%_%modversion%_Streams.big>> "%mydocs%\%userdataleaf%\Mods\%modname%\%modname%_%modversion%.skudef"
if exist "%mydocs%\%userdataleaf%\Mods\%modname%\Core\%modname%_%modversion%_Misc.big" echo add-big Core\%modname%_%modversion%_Misc.big>> "%mydocs%\%userdataleaf%\Mods\%modname%\%modname%_%modversion%.skudef"
if exist "%mydocs%\%userdataleaf%\Mods\%modname%\Meta\%modname%_%modversion%_Maps.big" echo add-big Meta\%modname%_%modversion%_Maps.big>> "%mydocs%\%userdataleaf%\Mods\%modname%\%modname%_%modversion%.skudef"


setlocal EnableDelayedExpansion

if exist "%cd%\Mods\%modname%\LanguagePacks" (
	set sdk=!cd!
	cd /D "!sdk!\Mods\%modname%\LanguagePacks"
	
	for /D %%A in ("*") do (
		echo Compiling %%A Language Pack...
		
		if exist "!sdk!\Compilation\Mods\%modname%\Data\AdditionalMaps\MapMetaData_Global.manifest" (
			set bps=-bps:"additionalmaps\mapmetadata_global.manifest,!sdk!\Compilation\Mods\%modname%\Data\AdditionalMaps\MapMetaData_Global.manifest"
		) else (
			set bps=
		)
		
		if exist "!cd!\%%A\Data\AdditionalMaps\MapMetaData_Global.xml" "!sdk!\Tools\WrathEd.exe" -gameDefinition:"Kane's Wrath" -compile:"!cd!\%%A\Data\AdditionalMaps\MapMetaData_Global.xml" -art:"..\..\Art;..\..\..\..\Art" -audio:"..\..\Audio;..\..\..\..\Audio" -out:"!sdk!\Compilation\Mods\%modname%\LanguagePacks\%%A\Data\AdditionalMaps" -version:"_LanguagePack" !bps!
		
		if exist "!sdk!\Compilation\Mods\%modname%\Data\AdditionalMaps\MapMetaData_GlobalOverrides.manifest" (
			set bps=-bps:"additionalmaps\mapmetadata_globaloverrides.manifest,!sdk!\Compilation\Mods\%modname%\Data\AdditionalMaps\MapMetaData_GlobalOverrides.manifest"
		) else (
			set bps=
		)
		
		if exist "!cd!\%%A\Data\AdditionalMaps\MapMetaData_GlobalOverrides.xml" "!sdk!\Tools\WrathEd.exe" -gameDefinition:"Kane's Wrath" -compile:"!cd!\%%A\Data\AdditionalMaps\MapMetaData_GlobalOverrides.xml" -art:"..\..\Art;..\..\..\..\Art" -audio:"..\..\Audio;..\..\..\..\Audio" -out:"!sdk!\Compilation\Mods\%modname%\LanguagePacks\%%A\Data\AdditionalMaps" -version:"_LanguagePack" !bps!
		
		if exist "!sdk!\Compilation\Mods\%modname%\Data\Global%streamversion%.manifest" (
			set bps=-bps:"global_%%A_2.manifest,!sdk!\Game Files\Manifest\global_%%A_2.manifest"
		) else (
			set bps=
		)
		
		if exist "!cd!\%%A\Data\Global.xml" "!sdk!\Tools\WrathEd.exe" -gameDefinition:"Kane's Wrath" -compile:"!cd!\%%A\Data\Global.xml" -art:"..\Art;..\..\..\Art" -audio:"..\Audio;..\..\..\Audio" -data:"..\Data;..\..\..\Data" -out:"!sdk!\Compilation\Mods\%modname%\LanguagePacks\%%A\Data" -version:"_%%A%streamversion%" !bps!

		if exist "!sdk!\Compilation\Mods\%modname%\Data\MapMetaData%streamversion%.manifest" (
			set bps=-bps:"mapmetadata%streamversion%.manifest,!sdk!\Compilation\Mods\%modname%\Data\MapMetaData%streamversion%.manifest"
		) else (
			set bps=-bps:"mapmetadata.manifest,!sdk!\Game Files\Manifest\MapMetaData.manifest"
		)
		
		if exist "!cd!\%%A\Data\MapMetaData.xml" "!sdk!\Tools\WrathEd.exe" -gameDefinition:"Kane's Wrath" -compile:"!cd!\%%A\Data\MapMetaData.xml" -art:"..\Art;..\..\..\Art" -audio:"..\Audio;..\..\..\Audio" -out:"!sdk!\Compilation\Mods\%modname%\LanguagePacks\%%A\Data" -version:"_LanguagePack" -lowlod:"mapmetadata_languagepack.manifest" !bps!

		if exist "!sdk!\Compilation\Mods\%modname%\Data\MetaGame%streamversion%.manifest" (
			set bps=-bps:"metagame%streamversion%.manifest,!sdk!\Compilation\Mods\%modname%\Data\MetaGame%streamversion%.manifest"
		) else (
			set bps=-bps:"metagame.manifest,!sdk!\Game Files\Manifest\MetaGame.manifest"
		)
		
		if exist "!cd!\%%A\Data\MetaGame.xml" "!sdk!\Tools\WrathEd.exe" -gameDefinition:"Kane's Wrath" -compile:"!cd!\%%A\Data\MetaGame.xml" -art:"..\Art;..\..\..\Art" -audio:"..\Audio;..\..\..\Audio" -out:"!sdk!\Compilation\Mods\%modname%\LanguagePacks\%%A\Data" -version:"_LanguagePack" -lowlod:"metagame_languagepack.manifest" !bps!

		set dir=!cd!
		cd /D "!sdk!\Game Files\Manifest\AptUI"
		
		for %%B in ("*.manifest") do (
			if exist "!sdk!\Compilation\Mods\%modname%\LanguagePacks\%%A\Data\AptUI\%%~nB%streamversion%.manifest" (
				set bps=-bps:"aptui\%%~nB%streamversion%.manifest,!sdk!\Compilation\Mods\%modname%\LanguagePacks\%%A\Data\Aptui\%%~nB%streamversion%.manifest"
			) else (
				set bps=-bps:"aptui\%%~nB.manifest,!sdk!\Game Files\Manifest\AptUI\%%~nB.manifest"
			)
		
			if exist "!dir!\%%A\Data\AptUI\%%~nB.xml" "!sdk!\Tools\WrathEd.exe" -gameDefinition:"Kane's Wrath" -compile:"!dir!\%%A\Data\AptUI\%%~nB.xml" -art:"..\..\Art;..\..\..\..\Art" -audio:"..\..\Audio;..\..\..\..\Audio" -out:"!sdk!\Compilation\Mods\%modname%\LanguagePacks\%%A\Data\AptUI" -version:"_LanguagePack" !bps!
			
		)
		
		cd /D "!dir!"
		set dir=
		
		if exist "!sdk!\Compilation\Mods\%modname%\LanguagePacks\%%A" "!sdk!\Tools\MakeBig.exe" -f "!sdk!\Compilation\Mods\%modname%\LanguagePacks\%%A" -o:"%mydocs%\%userdataleaf%\Mods\%modname%\Core\%modname%_%modversion%_Streams_%%A.big"
		if exist "!cd!\%%A\Misc" "!sdk!\Tools\MakeBig.exe" -f "!cd!\%%A\Misc" -o:"!sdk!\Compilation\Mods\%modname%\LanguagePacks\%%A" -o:"%mydocs%\%userdataleaf%\Mods\%modname%\Core\%modname%_%modversion%_Misc_%%A.big"
	)
	
	cd /D "!sdk!"
	set sdk=
)

endlocal EnableDelayedExpansion

:eof