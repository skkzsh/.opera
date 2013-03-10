<#
.SYNOPSIS
Make Symbolic Links or Copy Setting Files
in order to Share Opera Settings with Opera Next ones
#>

## TODO: Env

#### Setting

### Folders of Opera & Opera Next
$dst_color = 'Opera Next'
#$dst_color = 'Opera'

$app_opera      = "$ENV:APPDATA\Opera"
$localapp_opera = "$ENV:LOCALAPPDATA\Opera"

switch ($ENV:COMPUTERNAME) {
    default {
        $prefix_app_src      = $app_opera
        $prefix_localapp_src = $localapp_opera
    }
}

### TODO: Hash
$src_color = 'Opera'
$app_src      = "$prefix_app_src\$src_color"
$localapp_src = "$prefix_localapp_src\$src_color"
$app_dst      = "$app_opera\$dst_color"
$localapp_dst = "$localapp_opera\$dst_color"

### EXIT if These Folders NOT Exist
$app_src, $localapp_src, $app_dst, $localapp_dst | % {
    if (-not(Test-Path $_)) {
        $Host.UI.WriteErrorLine("Error: $_ not exists.")
        exit 1
    }
}

### File List of 'MKLINK' & 'COPY'
### TODO: Hash
$setup_files = @{
    app = @{
        ln = @{
            files = $null
            folders = 'sessions'
        }
        cp = @{
            files = 'global_history.dat', 'opcacrt6.dat', 'opcert6.dat', 'opssl6.dat', 'typed_history.xml', 'wand.dat'
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
            folders = 'widgets'
        }
    }
}

### APPDATA
## Symbolic Link
## Folders
$setup_files.app.ln.folders | % {
    smartln.ps1 mklink "$app_src\$_" "$app_dst\$_"
}

### COPY
## Files
$setup_files.app.cp.files | % {
    smartln.ps1 copy "$app_src\$_" "$app_dst\$_"
}

### LOCALAPPDATA
## Symbolic Link
## Folders
#$ln_localapp_folders | % {
#    smartln.ps1 mklink "$localapp_src\$_" "$localapp_dst\$_"
#}

## COPY
## Folders
$cp_localapp_folders | % {
    smartln.ps1 copy "$localapp_src\$_" "$localapp_dst\$_"
}

exit 0
