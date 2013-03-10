<#
.SYNOPSIS
Fix Widget Installation
by Removing widgets/{*.oex, wuid-*}
#>

$extensions = 'autopatchwork'

### Opera or Opera Next
$color = 'Opera'
# $color = 'Opera Next'

### Opera Folders
$localapp = "$ENV:LOCALAPPDATA\Opera\$color\widgets"

### EXIT if These Folders NOT Exist
$localapp | % {
    if (-not(Test-Path $_)) {
        $Host.UI.WriteErrorLine("Error: $_ not exists.")
        exit 1
    }
}

## XXX
## Get wuid ID
cd $localapp
foreach ($ext in $extensions) {
    #$wuids = $(
    #        Select-String -Context 1,0 $extensions "$localapp\widgets.dat" |
    #        Out-String -stream |
    #        Select-String section |
    #        % {($_ -Split('"'))[1]}
    #        )
    $wuids = $(
            Select-String -Context 1,0 $ext "widgets.dat" |
            Out-String -Stream |
            Select-String section |
            % { ( $_ -Split('"') )[1] }
            )
    Write-Output "--- $ext ---"
    Write-Output $wuids
}

## Remove oex files
$extensions | % {
    rm -Confirm "$localapp\$_*.oex"
}

## Remove wuids folders
$wuids | % {
    rm -Confirm "$localapp\$_"
}
