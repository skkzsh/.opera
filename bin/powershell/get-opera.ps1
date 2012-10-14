<#
.SYNOPSIS
Get My Opera Setting Files from Internet
#>

## TODO: Env

### Opera or Opera Next
$color = 'Opera'
# $color = 'Opera Next'

$app = "$ENV:APPDATA/Opera/$color"

### EXIT if Folder NOT Exist
foreach ($dir in $app) {
    if (-not(Test-Path $dir)) {
        Write-Error "$dir not exists."
        exit 1
    }
}

$get_files = 'search.ini', 'keyboard/my_keyboard.ini', 'mouse/my_mouse.ini', 'toolbar/my_toolbar.ini'
$get_url = 'https://raw.github.com/skkzsh/.opera/master'

$wc = New-Object System.Net.WebClient
foreach ($file in $get_files) {
    #Write-Progress -a "Download $file" -st "from $get_url to $app ..."
    Write-Output "--- Download $file ---" "from $get_url" "to $app ..."
    $wc.DownloadFile("$get_url/$file", "$app/$file")
}

exit 0
