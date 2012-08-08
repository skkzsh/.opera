@ECHO OFF
SETLOCAL

GOTO :POD

=head1 NAME

smartln.bat - Symbolic Link or Copy Carefully

=head1 SYNOPSIS

    :: Symbolic Link from Source to Destination
    smartln.bat "mklink" "source" "destination1"

    :: Copy from Source to Destination
    smartln.bat "copy" "source" "destination2"

=head1 DESCRIPTION

Symbolic Link or Copy Carefully

=cut
:POD

:::: TODO: Error処理をちゃんと書く

:::: 引数が3個でなければ中断
SET argc=0
FOR %%i IN (%*) DO (
    SET /a argc+=1
)
IF %argc% NEQ 3 (
    ECHO Error      : No. of arguments must be 3. >&2
    CALL :usage %0
    EXIT /B 1
)

:::: 引数の命名
SET cmd=%1
SET src=%2
SET dst=%3
SET src_type=%~a2
SET dst_type=%~a3

:::: Exception Handling
::: Commandが有効でなければError
IF /I %cmd% NEQ "mklink" IF /I %cmd% NEQ "copy" (
    ECHO Error: Invalid Option %cmd% >&2
    CALL :usage %0
    EXIT /B 1
)
::: Link元が存在しなければError
IF NOT EXIST %src% (
    ECHO Error: Source %src% not exists. >&2
    CALL :usage %0
    EXIT /B 1
)

:::: Link先が存在すれば削除
IF EXIST %dst% (
    IF "%dst_type%" == "d--------" (
        RD %dst% && ECHO Removed
    ) ELSE IF "%dst_type%" == "--a------" (
        DEL /P %dst% && ECHO Deleted
    ) ELSE IF "%dst_type%" == "d-------l" (
        RD %dst% && ECHO Removed
    ) ELSE IF "%dst_type%" == "--a-----l" (
        DEL /P %dst% && ECHO Deleted
    ) ELSE (
        ECHO DELETE Error >&2
    )

) ELSE (
    ECHO Announce    : Try to remove %dst%, but not exists.
)

:::: Symbolic Link or Copy
IF EXIST %dst% (
    ECHO Announce    : %dst% exists, so not make link. >&2

) ELSE IF /I %cmd% == "mklink" (
    IF "%src_type%" == "d--------" (
        MKLINK /D %dst% %src%
    ) ELSE IF "%src_type%" == "--a------" (
        MKLINK %dst% %src%
    ) ELSE (
        ECHO MKLINK Error >&2
    )

) ELSE IF /I %cmd% == "copy" (
    IF "%src_type%" == "d--------" (
        COPY /-Y %src% %dst%
    ) ELSE IF "%src_type%" == "--a------" (
        COPY /-Y %src% %dst%
    ) ELSE (
        ECHO COPY Error >&2
    )

) ELSE (
    ECHO Error: Invalid Option %cmd% >&2
    CALL :usage %0
    EXIT /B 1
)

ENDLOCAL
EXIT /B 0


:usage
where pod2usage > nul 2>&1 && pod2usage %1
EXIT /B 0
