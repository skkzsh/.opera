@ECHO OFF
SETLOCAL
::
:: DropboxにあるOpera (Next) の
:: 設定Fileを共有させるために
:: Symbolic Linkを張る,
:: またはCopyする.
::::::::::::::::::::::::::::::::::::::::::::::::::

:::: TODO

:::: Setup or Backup
:: SET mode=setup
:: SET mode=backup

:::: Opera or Opera Next
:: SET color=Opera
SET color=Opera Next

:::: lnとcpのList
SET ln_app_folders=keyboard mouse skin toolbar
:: SET ln_app_files=
:: SET cp_app_folders=
SET cp_app_files=override.ini search.ini
:: SET ln_local_folders=
:: SET ln_local_files=
:: SET cp_local_folders=
:: SET cp_local_files=

:::: BackupのList
:: SET backup_app_folders=
:: SET backup_app_files=
:: SET backup_local_folders=
:: SET backup_local_files=

::: LocalのOperaのDirectories
SET app=%APPDATA%\Opera\%color%
SET localapp=%LOCALAPPDATA%\Opera\%color%

::: DropboxのOperaのDirectory
IF %COMPUTERNAME% == KOSUKE-PC (
    SET prefix_dropbox=%USERPROFILE%\Documents\Dropbox
) ELSE (
    SET prefix_dropbox=%USERPROFILE%\Dropbox
)
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
::: TODO: 配列

FOR /L %%i in (1 1 2) DO (
    SET db_sig%%i=%dropbox%\mail\signature%%i.txt
)

SET localapp_sig=%localapp%\mail\signature

IF %COMPUTERNAME% == KOSUKE-PC (
    CALL smartln.bat "mklink" "%db_sig1%" "%localapp_sig%17.txt"
    CALL smartln.bat "mklink" "%db_sig2%" "%localapp_sig%21.txt"
) ELSE IF %COMPUTERNAME% == HASHI-PC (
    CALL smartln.bat "mklink" "%db_sig1%" "%localapp_sig%14.txt"
    CALL smartln.bat "mklink" "%db_sig2%" "%localapp_sig%18.txt"
) ELSE IF %COMPUTERNAME% == PC-6763 (
    CALL smartln.bat "mklink" "%db_sig1%" "%localapp_sig%15.txt"
    CALL smartln.bat "mklink" "%db_sig2%" "%localapp_sig%16.txt"
)

ENDLOCAL
EXIT /B 0
