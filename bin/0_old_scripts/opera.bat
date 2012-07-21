@echo off
::
:: DropboxÇ…Ç†ÇÈOpera (Next) ÇÃ
:: ê›íËFileÇã§óLÇ≥ÇπÇÈÇΩÇﬂÇ…
:: Symbolic LinkÇí£ÇÈ,
:: Ç‹ÇΩÇÕCopyÇ∑ÇÈ.
::
::::::::::::::::::::::::::::::::::::::::::::::::::

:::: TODO
:::: Opera or Opera Next
:: SET color=Opera
SET color=Opera Next

:::: Setting

::: LocalÇÃOperaÇÃDirectories
SET app="%APPDATA%\Opera\%color%"
SET localapp="%LOCALAPPDATA%\Opera\%color%"

::: DropboxÇÃOperaÇÃDirectory
IF %COMPUTERNAME% == KOSUKE-PC (
    SET prefix_dropbox=%HOMEPATH%\Documents\Dropbox
) ELSE (
    SET prefix_dropbox=%HOMEPATH%\Dropbox
)
SET dropbox=%prefix_dropbox%\setting\.opera


:::: lnÇ∆cpÇÃList
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
::: TODO: îzóÒ

FOR /L %%i in (1 1 2) DO (
    SET db_sig%%i=%dropbox%\mail\signature%%i.txt
)

SET localapp_sig=%localapp%\mail\signature

IF %COMPUTERNAME% == KOSUKE-PC (
    DEL /P %localapp_sig%17.txt
    MKLINK %localapp_sig%17.txt %db_sig1%
    DEL /P %localapp_sig%21.txt
    MKLINK %localapp_sig%21.txt %db_sig2%
) ELSE IF %COMPUTERNAME% == HASHI-PC (
    DEL /P %localapp_sig%14.txt
    MKLINK %localapp_sig%14.txt %db_sig1%
    DEL /P %localapp_sig%18.txt
    MKLINK %localapp_sig%18.txt %db_sig2%
) ELSE IF %COMPUTERNAME% == PC-6763 (
    DEL /P %localapp_sig%15.txt
    MKLINK %localapp_sig%15.txt %db_sig1%
    DEL /P %localapp_sig%16.txt
    MKLINK %localapp_sig%16.txt %db_sig2%
)
