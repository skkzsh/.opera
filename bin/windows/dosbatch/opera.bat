@ECHO OFF
SETLOCAL
::
:: Dropbox‚É‚ ‚éOpera (Next) ‚Ì
:: Ý’èFile‚ð‹¤—L‚³‚¹‚é‚½‚ß‚É
:: Symbolic Link‚ð’£‚é,
:: ‚Ü‚½‚ÍCopy‚·‚é.
::
:: Bookmark‚Íopera:config (operaprefs.ini) ‚Å
:: Dropbox“à‚Ìbookmar.adr‚ð’¼ÚŽw’è
::::::::::::::::::::::::::::::::::::::::::::::::::

:::: TODO

:::: Setup or Backup
SET mode=setup
:: SET mode=backup

:::: Opera or Opera Next
:: SET color=Opera
SET color=Opera Next

:::: ln‚Æcp‚ÌList
SET ln_app_folders=keyboard mouse skin toolbar
:: SET ln_app_files=
:: SET cp_app_folders=
SET cp_app_files=override.ini search.ini
:: SET ln_local_folders=
:: SET ln_local_files=
:: SET cp_local_folders=
:: SET cp_local_files=

:::: Backup‚ÌList
:: SET backup_app_folders=
:: SET backup_app_files=
:: SET backup_local_folders=
:: SET backup_local_files=

::: Local‚ÌOpera‚ÌDirectories
SET app=%APPDATA%\Opera\%color%
SET localapp=%LOCALAPPDATA%\Opera\%color%

::: Dropbox‚ÌOpera‚ÌDirectory
SET prefix_dropbox=%USERPROFILE%\Dropbox
SET dropbox=%prefix_dropbox%\setting\.opera
::: EXIT if These Folders NOT Exist
FOR %%i IN ("%app%" "%localapp%" "%dropbox%") DO (
    IF NOT EXIST %%i (
        ECHO Error: %%i not exists. >&2
        EXIT /B 1
    )
)

:::: Symbolic Link
::: APPDATA
:: Folders
FOR %%i IN (%ln_app_folders%) DO (
    CALL smartln.bat "mklink" "%dropbox%\%%i" "%app%\%%i"
)

:::: Copy
::: APPDATA
:: Files
FOR %%i in (%cp_app_files%) do (
    CALL smartln.bat "copy" "%dropbox%\%%i" "%app%\%%i"
)

::: Mail Signature
::: TODO: ”z—ñ

FOR /L %%i in (1 1 2) DO (
    SET db_sig%%i=%dropbox%\mail\signature%%i.txt
)

SET localapp_sig=%localapp%\mail\signature

ENDLOCAL
EXIT /B 0
