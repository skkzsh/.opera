<#
.SYNOPSIS
Symbolic Link and Copy Setting Files
in order to Share Opera Settings with Opera Next ones
#>

#### Setting

### Opera‚ÆOpera Next‚ÌDirecties
$red   = 'Opera'
$white = 'Opera Next'

$app_red        = "$ENV:APPDATA\Opera\$red"
$localapp_red   = "$ENV:LOCALAPPDATA\Opera\$red"
$app_white      = "$ENV:APPDATA\Opera\$white"
$localapp_white = "$ENV:LOCALAPPDATA\Opera\$white"

### EXIT if These Folders NOT Exist
foreach ($dir in $app_red, $localapp_red, $app_white, $localapp_white) {
    if (-not(Test-Path $dir)) {
        $Host.UI.WriteErrorLine("Error: $dir not exists.")
        exit 1
    }
}

### MKLINK‚ÆCOPY‚ÌList
### TODO: Hash
$ln_app_folders = 'sessions'
# $ln_app_files =
# $cp_app_folders =
$cp_app_files = 'global_history.dat', 'opcacrt6.dat', 'opcert6.dat', 'opssl6.dat', 'typed_history.xml', 'wand.dat'
$ln_localapp_folders = 'widgets'
# $ln_localapp_files =
# $cp_localapp_folders =
# $cp_localapp_files =

### Symbolic Link
## APPDATA
## Folders
foreach ($file in $ln_app_folders) {
    smartln.ps1 mklink "$app_red\$file" "$app_white\$file"
}

### LOCALAPPDATA
## Folders
foreach ($file in $ln_localapp_folders) {
    smartln.ps1 mklink "$localapp_red\$file" "$localapp_white\$file"
}

### COPY
## APPDATA
## Files
foreach ($file in $cp_app_files) {
    smartln.ps1 copy "$app_red\$file" "$app_white\$file"
}

exit 0
