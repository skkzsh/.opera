#!/usr/bin/env perl
#
# DropboxにあるOpera (Next) の
# 設定Fileを共有させるために
# Symbolic Link and Copy
# or
# Opera (Next) の設定をDropboxにBackup (Copy)
#
# Bookmarkはopera:config (operaprefs.ini) で
# Dropbox内のbookmar.adrを直接指定
#
# [Path]
# Linux|~/.opera(-next)
# Mac  |~/Library/Opera (Next)                         |~/Library/Application Support/Opera (Next)
# Win  |C:\Users\xxx\AppData\Roaming\Opera\Opera (Next)|C:\Users\xxx\AppData\Local\Opera\Opera (Next)
########################################

use strict;
use warnings;
use 5.010;

use Sys::Hostname 'hostname';

use SmartLn;

#### Setup or Backup
my $mode;
$mode = 'setup';
# $mode = 'backup';

#### Opera or Opera Next
my $color;
# $color = 'red';
$color = 'white';

### 各Directoryに対してSymbolic Link and CopyするFiles
my @ln_library_files = qw( keyboard mouse toolbar );
my @ln_support_files;
my @cp_library_files = qw( override.ini search.ini );
my @cp_support_files;
my %setup_files = (
    library => { ln => \@ln_library_files, cp => \@cp_library_files },
    support => { ln => \@ln_support_files, cp => \@cp_support_files },
);
#### 各Directoryに対してBackupするFiles
my @backup_library_files = @cp_library_files;
my @backup_support_files;
my %backup_files = (
    library => \@backup_library_files,
    support => \@backup_support_files,
);

## DropboxのOperaのDirectory
## TODO: WindowsのENVで\を/に変換
my $prefix_dropbox;
if ( $^O eq 'MSWin32' ) {
    if ( hostname =~ /^KOSUKE-PC$/i ) {
        $prefix_dropbox = "$ENV{USERPROFILE}/Documents";
    }
    else {
        $prefix_dropbox = "$ENV{USERPROFILE}";
    }
    $prefix_dropbox =~ s#\\#/#g;
}
else {
    $prefix_dropbox = "$ENV{HOME}";
}
my $dropbox = "$prefix_dropbox/Dropbox/setting/.opera";

given ($color) {
    when ('red')   { print 'Opera ' }
    when ('white') { print 'Opera Next ' }
    default        { exit 1 }
}
my %dir = &where_are_dirs($color);

given ($mode) {
    when ('setup') {
        say 'Setup !';
        &setup( $dropbox, \%dir, \%setup_files );
    }
    when ('backup') {
        say 'Backup !';
        &backup( $dropbox, \%dir, \%backup_files );
    }
    default { exit 1 }
}

### Outputs : Opera (Next) のDirectories (%dir)
### %dir{''}{'library'} :
### %dir{''}{'support'} :
### Arguments : $color
sub where_are_dirs {
    my $color = shift;

    my %dir;
    given ($^O) {

        ### Linux
        when ('linux') {
            given ($color) {
                when ('red')   { $dir{'library'} = "$ENV{HOME}/.opera" }
                when ('white') { $dir{'library'} = "$ENV{HOME}/.opera-next" }
                default        { exit 1 }
            }
            $dir{'support'} = $dir{'library'};
        }

        when (/^(darwin|MSWin32)$/) {
            my $color_dir;
            given ($color) {
                when ('red')   { $color_dir = 'Opera' }
                when ('white') { $color_dir = 'Opera Next' }
                default        { exit 1 }
            }

            given ($^O) {
                ### Mac
                when ('darwin') {
                    $dir{'library'}
                        = "$ENV{HOME}/Library/$color_dir";
                    $dir{'support'}
                        = "$ENV{HOME}/Library/Application Support/$color_dir";
                }
                ### Win
                when ('MSWin32') {
                    $dir{'library'} = "$ENV{APPDATA}/Opera/$color_dir";
                    $dir{'support'} = "$ENV{LOCALAPPDATA}/Opera/$color_dir";
                    $dir{'library'} =~ s#\\#/#g;
                    $dir{'support'} =~ s#\\#/#g;
                }
                default { exit 1 }
            }
        }

        default { exit 1 }
    }

    ### Directoryが存在しなければDie
    for my $dir ( values %dir ) {
        die "Error: $dir not exists." unless -d $dir;
    }

    %dir;
}

### DropboxからOpera (Next) へFilesをSymbolic Link and Copy
### Arguments
### $dropbox         : Dropbox内のOperaとOperaDirectory
### $dir_ref         : Opera (Next) のDirectories(のReference)
### $setup_files_ref : 各Directoryに対してSymbolic Link and CopyするFiles(のReference)
sub setup {
    my ( $dropbox, $dir_ref, $setup_files_ref ) = @_;

    for my $dir_type (qw (library support)) {
        for my $cmd (qw (ln cp)) {
            for my $file ( @{ $setup_files_ref->{$dir_type}{$cmd} } ) {
                smartln(
                    $cmd,
                    "$dropbox/$file",
                    "$$dir_ref{$dir_type}/$file"
                );
            }
        }
    }

    ### Mail Signaure
    given (hostname) {
        when (/^(sing|drive|leap|box)/) {
            &ln_signature( $dropbox, $$dir_ref{'support'}, 1, 2 );
        }
        when (/^KOSUKE-PC$/i) {
            &ln_signature( $dropbox, $$dir_ref{'support'}, 17, 21 );
        }
        when (/^HASHI-PC$/i) {
            &ln_signature( $dropbox, $$dir_ref{'support'}, 14, 18 );
        }
        when (/^PC-6763$/i) {
            &ln_signature( $dropbox, $$dir_ref{'support'}, 15, 16 );
        }
        default { exit 1 }
    }

}

### DropboxからOpera (Next) へMail SignatureをSymbolic Link
### Arguments
### $dropbox     : Dropbox内のOperaとOperaDirectory
### $dir_support : Opera (Next) のApplication SuppportのDirectory
### @numbers     : Mail Accountの番号
sub ln_signature {
    my ( $dropbox, $dir_support, @numbers ) = @_;

    my @db_sig = map {"$dropbox/mail/signature$_.txt"} 0 .. 2;

    my $i;
    for (@numbers) {
        smartln( 'ln', $db_sig[ ++$i ], "$dir_support/mail/signature$_.txt" );
    }
}

### Opera (Next) からDropboxへFilesをBackup (Copy)
### Arguments
### $dropbox          : Dropbox内のOperaとOperaDirectory
### $dir_ref          : Opera (Next) のDirectories(のReference)
### $backup_files_ref : 各Directoryに対してBackup (Copy) するFiles(のReference)
sub backup {
    my ( $dropbox, $dir_ref, $backup_files_ref ) = @_;

    for my $dir_type (qw (library support)) {
        for my $file ( @{ $backup_files_ref->{$dir_type} } ) {
            smartln( 'cp', "$$dir_ref{$dir_type}/$file", "$dropbox/$file" );
        }
    }
}
