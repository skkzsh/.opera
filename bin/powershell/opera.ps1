<#

.SYNOPSIS

<Setup Mode>
Make Symbolic Links or Copy
Opera [Next] Setting Files
from Dropbox or Repository

#>

## TODO: Env

### Setup or Backup
# $mode = 'setup'
# $mode = 'backup'

### Opera or Opera Next
$color = 'Opera'
# $color = 'Opera Next'


### Opera Folder in Dropbox or Repository
switch ($ENV:COMPUTERNAME) {
    default           { $prefix = "$ENV:USERPROFILE" }
}
$dropbox = "$prefix\Dropbox\Computer\Settings\.opera"
$repos = "$prefix\Repository\bitbucket\unix_files\.opera"

### Opera Folders on Local
$app = "$ENV:APPDATA\Opera\$color"
$localapp = "$ENV:LOCALAPPDATA\Opera\$color"

### EXIT if These Folders NOT Exist
$app, $localapp, $dropbox, $repos | % {
    if (-not(Test-Path $_)) {
        $Host.UI.WriteErrorLine("Error: $_ not exists.")
        exit 1
    }
}

Write-Output "$color Setup!"

### File List of 'MKLINK' & 'COPY'
## TODO: Skin Toolbar
## FIXME: Hash
$setup_files = @{
    app = @{
        repos = @{
            ln = @{
                files = $null
                folders = 'keyboard', 'mouse'
            }
            cp = @{
                files = 'override.ini', 'search.ini'
                folders = 'toolbar'
            }
        }
        dropbox = @{
            ln = @{
                files = $null
                folders = 'skin'
            }
            cp = @{
                files = $null
                folders = $null
            }
        }
    }

    local = @{
        repos = @{
            ln = @{
                files = $null
                folders = $null
            }
            cp = @{
                files = $null
                folders = $null
            }
        }
        dropbox = @{
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
}

### Backup File List
# $backup_app_folders =
# $backup_app_files =
# $backup_local_folders =
# $backup_local_files =

### TODO: Keys, Values

### Symbolic Link
## APPDATA
## Folders
$setup_files.app.repos.ln.folders | % {
    smartln.ps1 mklink "$repos\$_" "$app\$_"
}
$setup_files.app.dropbox.ln.folders | % {
    smartln.ps1 mklink "$dropbox\$_" "$app\$_"
}

### Copy
## APPDATA
## Files
$setup_files.app.repos.cp.files | % {
    smartln.ps1 copy "$repos\$_" "$app\$_"
}
## Folders
$setup_files.app.repos.cp.folders | % {
    smartln.ps1 copy "$repos\$_" "$app\$_"
}

### Mail Signature
## TODO: Variable Expansion

switch ($ENV:COMPUTERNAME) {
    default     { $num = 0 }
}

if ($num -ne 0) {
    1..2 | % {
        smartln.ps1 mklink "$repos\mail\signature$_.txt" "$localapp\mail\signature$($num[$($_ - 1)]).txt"
    }
}

exit 0
