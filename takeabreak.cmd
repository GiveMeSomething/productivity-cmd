@echo off

:YESOPTION

cls

:WRONGINPUT
set time=
set realtime=
set choice=
set secondToHour=3600
set secondToMinute=60

setlocal enabledelayedexpansion
set /p time=Enter time (second) or choose pre-defined time: ^

1. 30' ^

2. 45' ^

3. 1h ^

4. 1h30' ^

5. 2h ^

6. Pomodoro (experimental) ^

Your selection: 

set /a Test=time

if !Test! EQU 0 (
	if !time! NEQ 0 (
		@echo ^

Invalid input! Please re-enter time ^ 

		
		goto WRONGINPUT
	)
)

if !time! LEQ 0 (
		@echo ^

Invalid time! Please re-enter time ^ 

		
		goto WRONGINPUT
	)
if !time! GTR 9999 (
		@echo ^

Invalid time! Please re-enter time ^ 

		
		goto WRONGINPUT
	)

set realtime=%time%

rem set default hour and minute value
set hour=0
set minute=0
if !time! GEQ 3600 (
	set /a hour=%time%/%secondToHour%

	set /a time -= !hour!*%secondToHour%

	set /a minute=!time!/%secondToMinute%

	set /a time -= !minute!*%secondToMinute%
) else (
	set /a minute=!time!/%secondToMinute%
)

rem Weird script to add hour and minute to current time
for /f "tokens=1*" %%A in ('
  powershell -NoP -C "(Get-Date).AddMinutes(!minute!).AddHours(!hour!).ToString('yyyy/MM/dd HH:mm:ss')"
') do (
  set "AddedTime=%%B"
)

if "%time%" == "1" (set realtime=1800)
if "%time%" == "2" (set realtime=2700)
if "%time%" == "3" (set realtime=3600)
if "%time%" == "4" (set realtime=5400)
if "%time%" == "5" (set realtime=7200)
if "%time%" == "6" (goto POMODOROSTART)

@echo Computer will enter hibernate at %AddedTime%, in !hour! hour(s), !minute! minute(s) and !time! second(s)

timeout /nobreak !realtime!



set /p choice=Continue using[Y/N]?

if "%choice%" == "Y" (goto YESOPTION)
if "%choice%" == "y" (goto YESOPTION)

if "%choice%" == "N" (goto NOOPTION)
if "%choice%" == "n" (goto NOOPTION)

goto END

:NOOPTION
@echo Thanks for using this scripts ^

This scripts will shutdown in 5 seconds
timeout /nobreak 5
exit

:POMODOROSTART
@echo ^

This timer will run 4 times, 25 mins each, with 3 breaks ^

Please take a big break after that ^



set pomodorotime=0

:POMODOROLOOP
set /a numtime=pomodorotime + 1
set pomodorotime=%numtime%

@echo Starting loop number %pomodorotime%
timeout /nobreak 1500
start "" cmd /wait /c "echo End of loop&echo Please take a break&echo This window will automically close in 10 seconds&timeout 30& exit"

if %pomodorotime% == 4 (goto POMODOROEND) else (goto POMODOROCHOICE)

:POMODOROCHOICE
set /p choice=Continue using[Y/N]?

if "%choice%" == "Y" (goto POMODOROLOOP)
if "%choice%" == "y" (goto POMODOROLOOP)

if "%choice%" == "N" (goto POMODOROEND)
if "%choice%" == "n" (goto POMODOROEND)

:POMODOROEND
@echo Congrats for completing a Pomodoro Cycle ^

Please take a 20-30 mins break to refresh your mind :3 ^

Computer will enter hibernate after 60 seconds
timeout /nobreak 60
shutdown -h

:END
cmd /k