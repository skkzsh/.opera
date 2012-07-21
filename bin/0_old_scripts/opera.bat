@echo off
::
:: DropboxにあるOpera (Next) の
:: 設定Fileを共有させるために
:: Symbolic Linkを張る,
:: またはCopyする.
::
::::::::::::::::::::::::::::::::::::::::::::::::::

:::: TODO
:::: Opera or Opera Next
:: SET color=Opera
SET color=Opera Next

:::: Setting

::: LocalのOperaのDirectories
SET app="%APPDATA%\Opera\%color%"
SET localapp="%LOCALAPPDATA%\Opera\%color%"

::: DropboxのOperaのDirectory
SET prefix_dropbox=%HOMEPATH%\Dropbox
SET dropbox=%prefix_dropbox%\setting\.opera


:::: lnとcpのList
SET ln_app_folders=keyboard mouse skin toolbar
SET cp_app_files=override.ini search.ini

:::: Symbolic Link
::: APPDATA
:: Folders
FOR %%i IN (%ln_app_folders%) DO (
    RD %app%\%%i
    MKLINK /D %app%\%%i %dropbox%\%%i
)

:::: Copy
::: APPDATA
:: Files
for %%i in (%cp_app_files%) do (
    DEL /P %app%\%%i
    COPY /-Y %dropbox%\%%i %app%\%%i
)

::: Mail Signature
::: TODO: 配列

FOR /L %%i in (1 1 2) DO (
    SET db_sig%%i=%dropbox%\mail\signature%%i.txt
)

SET localapp_sig=%localapp%\mail\signature
