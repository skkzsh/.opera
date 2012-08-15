@ECHO OFF
SETLOCAL
::
:: Opera Next‚ÆOpera‚ÌÝ’è‚ð
:: ‹¤—L‚³‚¹‚é‚½‚ß‚É
:: Symbolic Link‚ð’£‚é,
:: ‚Ü‚½‚ÍCopy‚·‚é.
::::::::::::::::::::::::::::::::::::::::::::::::::

:::: Setting

::: MKLINK‚ÆCOPY‚ÌList
SET ln_app_folders=sessions
:: SET ln_app_files=
:: SET cp_app_folders=
SET cp_app_files=global_history.dat opcacrt6.dat opcert6.dat opssl6.dat typed_history.xml wand.dat
SET ln_localapp_folders=widgets
:: SET ln_localapp_files=
:: SET cp_localapp_folders=
:: SET cp_localapp_files=

::: Opera‚ÆOpera Next‚ÌDirecties
SET red=Opera
SET white=Opera Next

SET app_red=%APPDATA%\Opera\%red%
SET localapp_red=%LOCALAPPDATA%\Opera\%red%
SET app_white=%APPDATA%\Opera\%white%
SET localapp_white=%LOCALAPPDATA%\Opera\%white%

::: EXIT if These Folders NOT Exist
FOR %%i IN ("%app_red%" "%localapp_red%" "%app_white%" "%localapp_white%") DO (
    IF NOT EXIST %%i (
        ECHO Error: %%i not exists. >&2
        EXIT /B 1
    )
)

:::: Symbolic Link
::: APPDATA
:: Folders
FOR %%i IN (%ln_app_folders%) DO (
    CALL smartln.bat "mklink" "%app_red%\%%i" "%app_white%\%%i"
)
::: LOCALAPPDATA
:: Folders
FOR %%i IN (%ln_localapp_folders%) DO (
    CALL smartln.bat "mklink" "%localapp_red%\%%i" "%localapp_white%\%%i"
)

:::: COPY
::: APPDATA
:: Files
FOR %%i IN (%cp_app_files%) DO (
    CALL smartln.bat "copy" "%app_red%\%%i" "%app_white%\%%i"
)

ENDLOCAL
EXIT /B 0
