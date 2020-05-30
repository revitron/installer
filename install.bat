@echo off

set pwd=%CD%
set install=%CD%\jarvis-pyrevit
set repo=https://github.com/revitron/pyRevit.git
set jarvis=https://github.com/revitron/jarvis.git
set jarvisUI=https://github.com/revitron/jarvis-ui.git
set revitron=https://github.com/revitron/revitron.git
set revitronUi=https://github.com/revitron/revitron-ui.git
set extensions=%install%\extensions

if exist %install% (
    del /s /q /f "%install%\.git\*"
    rmdir /s /q "%install%\.git"
    del /s /q /f "%install%\*"
    rmdir /s /q "%install%"
)

timeout 3

git clone %repo% %install%

echo Installing core extensions ...
%install%\bin\pyrevit extend lib jarvis %jarvis% --dest=%extensions%
%install%\bin\pyrevit extend ui jarvis-ui %jarvisUI% --dest=%extensions%
%install%\bin\pyrevit extend lib revitron %revitron% --dest=%extensions%
%install%\bin\pyrevit extend ui revitron-ui %revitronUi% --dest=%extensions%

cd /D %pwd%