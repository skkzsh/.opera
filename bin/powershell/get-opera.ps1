<#
=head1 DESCRIPTION

Get My Opera Setting Files from Internet

=cut
#>

### Opera or Opera Next
$color = 'Opera'
# $color = 'Opera Next'

$app = "$ENV:APPDATA/Opera/$color"

### EXIT if Folder NOT Exist
foreach ($dir in $app) {
    if (-not(Test-Path $dir)) {
        # "Error: $dir not exists." >&2
        "Error: $dir not exists."
        exit 1
    }
}

$get_files = 'search.ini', 'keyboard/my_keyboard.ini', 'mouse/my_mouse.ini', 'toolbar/standard_toolbar.ini'
$get_url = 'https://raw.github.com/skkzsh/.opera/master'

$hoge = New-Object System.Net.WebClient
foreach ($file in $get_files) {
    echo "--- Download $file ---" "from $get_url" "to $app ..."
    $hoge.DownloadFile("$get_url/$file", "$app/$file")
    # (new-object System.Net.WebClient).DownloadFile("$get_url/$file", "$app/$file")
}

exit 0
