@echo off

set pwd=%CD%
set install=%CD%\rpm-pyrevit
set pyrevit=https://github.com/revitron/pyRevit.git
set rpm=https://github.com/revitron/rpm.git
set revitron=https://github.com/revitron/revitron.git
set revitronUi=https://github.com/revitron/revitron-ui.git
set extensions=%install%\extensions
set bin=%install%\bin

if exist %install% (
    del /s /q /f "%install%\.git\*"
    rmdir /s /q "%install%\.git"
    del /s /q /f "%install%\*"
    rmdir /s /q "%install%"
)

timeout 3

git clone %pyrevit% %install%

echo Installing core extensions ...
%bin%\pyrevit extend ui rpm %rpmUI% --dest=%extensions%
%bin%\pyrevit extend lib revitron %revitron% --dest=%extensions%
%bin%\pyrevit extend ui revitron-ui %revitronUi% --dest=%extensions%

REM based on the legacy install-addin.bat
chcp 65001

cd /D %AppData%\Autodesk\Revit\Addins

for /D %%i in (2019 2020 2021) do (

    echo Removing legacy pyRevit addin for Revit %%i ...
    del "%CD%\%%i\pyRevit.addin"
    
)

rmdir /q /s "%AppData%\pyRevit"

cd /D %ProgramData%\Autodesk\Revit\Addins

for /D %%i in (2019 2020 2021) do (

	del "%CD%\%%i\rpm.addin"

	echo Adding addin description file to Revit %%i ...
	(
		echo ^<?xml version="1.0" encoding="utf-8" standalone="no"?^>
		echo ^<RevitAddIns^>
		echo   ^<AddIn Type="Application"^>
		echo     ^<Name^>PyRevitLoader^</Name^>
		echo     ^<Assembly^>%bin%\engines\277\pyRevitLoader.dll^</Assembly^>
		echo     ^<AddInId^>B39107C3-A1D7-47F4-A5A1-532DDF6EDB5E^</AddInId^>
		echo     ^<FullClassName^>PyRevitLoader.PyRevitLoaderApplication^</FullClassName^>
		echo   ^<VendorId^>eirannejad^</VendorId^>
		echo   ^</AddIn^>
		echo ^</RevitAddIns^>
	) > "%CD%\%%i\pyRevit.addin"

)

echo Clearing caches ...
%bin%\pyrevit caches clear --all

cd /D %pwd%