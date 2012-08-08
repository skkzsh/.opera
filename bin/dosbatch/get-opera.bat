@ECHO OFF
SETLOCAL

:::: Download Opera Setting Files from Internet

:::: Require curl (or wget) for Windows
:: SET get_cmd=wget
SET get_cmd=curl
where %get_cmd% > nul 2>&1
if %ERRORLEVEL% NEQ 0 (
    ECHO Error: Command %get_cmd% is required. >&2
    EXIT /B 1
)

:::: Opera or Opera Next
SET color=Opera
:: SET color=Opera Next

SET app=%APPDATA%\Opera\%color%

::: EXIT if Folder NOT Exist
FOR %%i IN ("%app%") DO (
    IF NOT EXIST %%i (
        ECHO Error: %%i not exists. >&2
        EXIT /B 1
    )
)

:::: Get

SET get_files=search.ini keyboard/my_keyboard.ini mouse/my_mouse.ini toolbar/standard_toolbar.ini
SET get_url=https://raw.github.com/skkzsh/.opera/master

FOR %%i IN (%get_files%) DO (
    curl %get_url%/%%i -o "%app%/%%i" -k
    rem wget %get_url%/%%i -P "%app%" --no-check-certificate
)

ENDLOCAL
EXIT /B 0
