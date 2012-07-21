#!/usr/bin/env perl
#
# Opera NextとOperaの設定を
# 共有させるために
# 設定FilesをSymbolic Link and Copy
#
# [Path]
# Linux|~/.opera(-next)
# Mac  |~/Library/Opera (Next)                         |~/Library/Application Support/Opera (Next)
# Win  |C:\Users\xxx\AppData\Roaming\Opera\Opera (Next)|C:\Users\xxx\AppData\Local\Opera\Opera (Next)
########################################

use strict;
use warnings;
use 5.010;

use SmartLn;

### 各Directoryに対してSymbolic Link and CopyするFiles
my %setup_files = (

    library => {
        ln => [
            qw( global_history.dat opcacrt6.dat opcert6.dat opssl6.dat typed_history.xml sessions wand.dat )
        ],
        cp => [qw()],
    },

    support => {
        ln => [qw( widgets )],
        cp => [qw()],
    },

);

my %dir = &where_are_dirs;
&setup( \%dir, \%setup_files );

### Outputs : OperaとOpera NextのDirectories (%dir)
### %dir{'red'}{''}     : OperaのDirectories
### %dir{'white'}{''}   : Opera NextのDirecties
### %dir{''}{'library'} :
### %dir{''}{'support'} :
sub where_are_dirs {
    my %dir;

    given ($^O) {

        ### Linux
        when ('linux') {
            $dir{'red'}{'library'} = $dir{'red'}{'support'}
                = "$ENV{HOME}/.opera";
            $dir{'white'}{'library'} = $dir{'white'}{'support'}
                = "$ENV{HOME}/.opera-next";
        }

        when (/^(darwin|MSWin32)$/) {
            my $red   = 'Opera';
            my $white = 'Opera Next';

            my ( $library, $support );
            given ($^O) {
                ### Mac
                when ('darwin') {
                    $library = "$ENV{HOME}/Library";
                    $support = "$ENV{HOME}/Library/Application Support";
                }
                ### Win
                when ('MSWin32') {
                    $library = "$ENV{APPDATA}/Opera";
                    $support = "$ENV{LOCALAPPDATA}/Opera";
                    $library =~ s#\\#/#g;
                    $support =~ s#\\#/#g;
                }
                default { exit 1 }
            }

            $dir{'red'}{'library'}   = "$library/$red";
            $dir{'red'}{'support'}   = "$support/$red";
            $dir{'white'}{'library'} = "$library/$white";
            $dir{'white'}{'support'} = "$support/$white";

        }

        default { exit 1 }
    }

    ### Directoriesが存在しなければDie
    for my $color_ref ( values %dir ) {
        for my $dir ( values %$color_ref ) {
            die "Error: $dir not exists." unless -d $dir;
        }
    }

    %dir;
}

### OperaからOpera NextへFilesをSymbolic Link and Copy
### Arguments
### $dir_ref         : OperaとOpera NextのDirectories(のReference)
### $setup_files_ref : 各Directoryに対してSymbolic Link and CopyするFiles(のReference)
sub setup {
    my ( $dir_ref, $setup_files_ref ) = @_;

    for my $dir_type (qw (library support)) {
        for my $cmd (qw (ln cp)) {
            for my $file ( @{ $setup_files_ref->{$dir_type}{$cmd} } ) {
                smartln(
                    $cmd,
                    "$$dir_ref{'red'}{$dir_type}/$file",
                    "$$dir_ref{'white'}{$dir_type}/$file"
                );
            }
        }
    }

}
