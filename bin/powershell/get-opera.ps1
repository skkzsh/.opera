<#
.SYNOPSIS
Get My Opera Setting Files from the Internet
#>

### Opera or Opera Next
$color = 'Opera'
# $color = 'Opera Next'

$app = "$ENV:APPDATA/Opera/$color"

### EXIT if Folders NOT Exist
$app | % {
    if (-not(Test-Path $_)) {
        Write-Error "$_ not exists."
        exit 1
    }
}

## TODO: Make dir
#'keyboard', 'mouse' | % {
#    if (-not(Test-Path "$app/$_")) {
#        md "$app/$_"
#    }
#}

$get_files = 'search.ini', 'keyboard/my_keyboard.ini', 'mouse/my_mouse.ini', 'toolbar/my_toolbar.ini'
$get_url = 'https://raw.github.com/skkzsh/.opera/master'

$wc = New-Object System.Net.WebClient
$get_files | % {
    #Write-Progress -a "Download $_" -st "from $get_url to $app ..."
    Write-Output "--- Download $_ ---" "from $get_url" "to $app ..."
    $wc.DownloadFile("$get_url/$_", "$app/$_")
}

exit 0
