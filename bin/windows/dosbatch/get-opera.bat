@ECHO OFF
SETLOCAL

GOTO :POD
=head1 DESCRIPTION

Get My Opera Setting Files from Internet

=cut
:POD

:::: Require curl (or wget) for Windows
SET get_cmd=curl
:: SET get_cmd=wget
FOR /F "tokens=1-6 delims=.[] " %%i in ('VER') DO (
    REM ECHO i=%%i j=%%j k=%%k l=%%l m=%%m n=%%n && EXIT /B 0 :: Debug
    IF %%k == Version ( :: Vista
        WHERE /Q %get_cmd%
        IF %ERRORLEVEL% NEQ 0 (
            ECHO Error: Command "%get_cmd%" is required. >&2
            EXIT /B 1
        )
    ) ELSE ( :: XP
        FOR %%i in (%get_cmd%.exe) DO (
            IF NOT EXIST %%~$PATH:i (
                ECHO Error: Command "%get_cmd%" is required. >&2
                EXIT /B 1
            )
        )
    )
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

:: TODO: New Line
FOR %%i IN (%get_files%) DO (
    ECHO Download %%i from %get_url% to %app% ...
    curl %get_url%/%%i -o "%app%/%%i" -k
    REM wget %get_url%/%%i -P "%app%" --no-check-certificate
)

ENDLOCAL
EXIT /B 0
