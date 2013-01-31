<#

.SYNOPSIS

[Setup Mode]
Make Symbolic Links or Copy
Opera [Next] Setting Files
from Dropbox

#>

## TODO: Env

### Setup or Backup
# $mode = 'setup'
# $mode = 'backup'

### Opera or Opera Next
$color = 'Opera'
# $color = 'Opera Next'


### Dropbox‚ÌOpera‚ÌDirectory
switch ($ENV:COMPUTERNAME) {
    default           { $prefix = "$ENV:USERPROFILE" }
}
$dropbox = "$prefix\Dropbox\setting\.opera"

### Local‚ÌOpera‚ÌDirectories
$app = "$ENV:APPDATA\Opera\$color"
$localapp = "$ENV:LOCALAPPDATA\Opera\$color"

### EXIT if These Folders NOT Exist
foreach ($dir in $app, $localapp, $dropbox) {
    if (-not(Test-Path $dir)) {
        $Host.UI.WriteErrorLine("Error: $dir not exists.")
        exit 1
    }
}

Write-Output "$color Setup!"

### MKLINK‚ÆCOPY‚ÌList
## TODO: Hash
## skin
$ln_app_folders = 'keyboard', 'mouse', 'toolbar', 'skin'
# $ln_app_files =
# $cp_app_folders = 'toolbar'
$cp_app_files = 'override.ini', 'search.ini'
# $ln_local_folders =
# $ln_local_files =
# $cp_local_folders =
# $cp_local_files =

$setup_files = @{
    app = @{
        ln = @{
            files = $null
            folders = $ln_app_folders
        }
        cp = @{
            files = $cp_app_files
            folders = $null
        }
    }

    local = @{
        ln = @{
            files = $null
            folders = $null
        }
        cp = @{
            files = $null
            folders = $null
        }
    }
}

### Backup‚ÌList
# $backup_app_folders =
# $backup_app_files =
# $backup_local_folders =
# $backup_local_files =

### Symbolic Link
## APPDATA
## Folders
foreach ($file in $setup_files.app.ln.folders) {
    smartln.ps1 mklink "$dropbox\$file" "$app\$file"
}

### Copy
## APPDATA
## Files
foreach ($file in $setup_files.app.cp.files) {
    smartln.ps1 copy "$dropbox\$file" "$app\$file"
}

### Mail Signature
## TODO: Variable Expansion

switch ($ENV:COMPUTERNAME) {
    default     { $num = 0 }
}

if ($num -ne 0) {
    foreach ($i in 1..2) {
        smartln.ps1 mklink "$dropbox\mail\signature$i.txt" "$localapp\mail\signature$($num[$($i - 1)]).txt"
    }
}

exit 0
