<#
=head1 DESCRIPTION

=head2 Setup Mode

Symbolic Link and Copy
Opera [Next] Setting Files
from Dropbox

=cut
#>

### Setup or Backup
# $mode = 'setup'
# $mode = 'backup'

### Opera or Opera Next
$color = 'Opera'
# $color = 'Opera Next'


### lnÇ∆cpÇÃList
$ln_app_folders = 'keyboard', 'mouse', 'skin', 'toolbar'
# $ln_app_files =
# $cp_app_folders =
$cp_app_files = 'override.ini', 'search.ini'
# $ln_local_folders =
# $ln_local_files =
# $cp_local_folders =
# $cp_local_files =

### BackupÇÃList
# $backup_app_folders =
# $backup_app_files =
# $backup_local_folders =
# $backup_local_files =

### LocalÇÃOperaÇÃDirectories
$app = "$ENV:APPDATA\Opera\$color"
$localapp = "$ENV:LOCALAPPDATA\Opera\$color"

### DropboxÇÃOperaÇÃDirectory
$prefix_dropbox = "$ENV:USERPROFILE\Dropbox"
$dropbox = "$prefix_dropbox\setting\.opera"
### EXIT if These Folders NOT Exist
foreach ($dir in $app, $localapp, $dropbox) {
    if (-not(Test-Path $dir)) {
        # "Error: $dir not exists." >&2
        "Error: $dir not exists."
        exit 1
    }
}

## TODO: CMD /C
### Symbolic Link
## APPDATA
## Folders
foreach ($file in $ln_app_folders) {
    CMD /C "smartln.bat `"mklink`" `"$dropbox\$file`" `"$app\$file`""
}

### Copy
## APPDATA
## Files
foreach ($file in $cp_app_files) {
    CMD /C "smartln.bat `"copy`" `"$dropbox\$file`" `"$app\$file`""
}

### Mail Signature
## TODO: ïœêîìWäJ

switch ($ENV:COMPUTERNAME) {
    default     { $ENV:COMPUTERNAME }
}

foreach ($i in 1..2) {
    CMD /C "smartln.bat `"mklink`" `"$dropbox\mail\signature$i.txt`" `"$localapp\mail\signature$($num[$($i - 1)]).txt`""
}

exit 0
