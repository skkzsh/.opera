@echo off
::
:: Opera Next��Opera�̐ݒ��
:: ���L�����邽�߂�
:: Symbolic Link�𒣂�,
:: �܂���Copy����.
::::::::::::::::::::::::::::::::::::::::::::::::::

:::: Setting

::: Opera��Opera Next��Directies
SET red=Opera
SET white=Opera Next

SET app_red=%APPDATA%\Opera\%red%
SET localapp_red=%LOCALAPPDATA%\Opera\%red%
SET app_white="%APPDATA%\Opera\%white%"
SET localapp_white="%LOCALAPPDATA%\Opera\%white%"

::: MKLINK��COPY��List
SET ln_localapp_folders=widgets
SET cp_app_files=global_history.dat opcacrt6.dat opcert6.dat opssl6.dat typed_history.xml sessions wand.dat

:::: Symbolic Link
::: LOCALAPPDATA
:: Folders
FOR %%i IN (%ln_localapp_folders%) DO (
    RD %localapp_white%\%%i
    MKLINK /D %localapp_white%\%%i %localapp_red%\%%i
)

:::: COPY
::: APPDATA
:: Files
FOR %%i IN (%cp_app_files%) DO (
    DEL /P %app_white%\%%i
    COPY /-Y %app_red%\%%i %app_white%\%%i
)
