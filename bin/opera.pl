#!/usr/bin/env perl

=head1 DESCRIPTION

=head2 Setup Mode

Symbolic Link and Copy
Opera [Next] Setting Files
from Dropbox

=head2 Backup Mode

Copy
Opera [Next] Setting Files
to Dropbox

=cut

use strict;
use warnings;
use 5.010;

use Sys::Hostname qw( hostname );
use File::Spec::Functions qw( catfile );

use SmartLn qw( smartln );

### Setup or Backup
my $mode;
$mode = 'setup';
## $mode = 'backup';

### Opera or Opera Next
my $color;
# $color = 'red';
$color = 'white';

### Symbolic Link and Copy Files for Each Directory
my @ln_library_files = qw( keyboard mouse toolbar );
my @ln_support_files;
my @cp_library_files = qw( override.ini search.ini );
my @cp_support_files;
my %setup_files = (
    library => { ln => \@ln_library_files, cp => \@cp_library_files },
    support => { ln => \@ln_support_files, cp => \@cp_support_files },
);
### Backup Files for Each Directory
my @backup_library_files = @cp_library_files;
my @backup_support_files;
my %backup_files = (
    library => \@backup_library_files,
    support => \@backup_support_files,
);

## Opera Directory in Dropbox
## TODO: WindowsのENVで\を/に変換
my $prefix_dropbox;
if ( $^O eq 'MSWin32' ) {
    $prefix_dropbox = $ENV{USERPROFILE};
}
else {
    $prefix_dropbox = $ENV{HOME};
}
my $dropbox = catfile $prefix_dropbox, 'Dropbox', 'setting', '.opera';

given ($color) {
    when ('red')   { print 'Opera ' }
    when ('white') { print 'Opera Next ' }
    default        { die $color }
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
    default { die $mode }
}

## Outputs : Opera (Next) のDirectories (%dir)
# %dir{''}{'library'} :
# %dir{''}{'support'} :
## Arguments : $color
sub where_are_dirs {
    my $color = shift;

    my %dir;
    given ($^O) {

        ### Linux
        when ('linux') {
            given ($color) {
                when ('red')   { $dir{'library'} = catfile $ENV{HOME}, '.opera' }
                when ('white') { $dir{'library'} = catfile $ENV{HOME}, '.opera-next' }
                default        { die $color }
            }
            $dir{'support'} = $dir{'library'};
        }

        when (/^(darwin|MSWin32)$/) {
            my $color_dir;
            given ($color) {
                when ('red')   { $color_dir = 'Opera' }
                when ('white') { $color_dir = 'Opera Next' }
                default        { die $color }
            }

            given ($^O) {
                ### Mac
                when ('darwin') {
                    $dir{'library'}
                        = catfile $ENV{HOME}, 'Library', $color_dir;
                    $dir{'support'}
                        = catfile $ENV{HOME}, 'Library', 'Application Support', $color_dir;
                }
                ### Win
                when ('MSWin32') {
                    $dir{'library'}
                        = catfile $ENV{APPDATA}, 'Opera', $color_dir;
                    $dir{'support'}
                        = catfile $ENV{LOCALAPPDATA}, 'Opera', $color_dir;
                }
                default { die $^O }
            }
        }

        default { die $^O }
    }

    ### Die if Directories NOT Exists
    for my $dir ( values %dir ) {
        die "Error: $dir not exists." unless -d $dir;
    }

    %dir;
}

## Symbolic Link and Copy Opera [Next] Setting Files from Dropbox
## Arguments
# $dropbox         : Opera Directory in Dropbox
# $dir_ref         : (Reference of) Directories of Opera [Next]
# $setup_files_ref : (Reference of) Symbolic Link and Copy Files for Each Directory
sub setup {
    my ( $dropbox, $dir_ref, $setup_files_ref ) = @_;

    for my $dir_type (qw( library support )) {
        for my $cmd (qw( ln cp )) {
            for my $file ( @{ $setup_files_ref->{$dir_type}{$cmd} } ) {
                smartln(
                    $cmd,
                    catfile( $dropbox,             $file ),
                    catfile( $$dir_ref{$dir_type}, $file )
                );
            }
        }
    }

    ### Mail Signaure
    given (hostname) {
        when (/^(sing|drive|leap|box)/) {
            &ln_signature( $dropbox, $$dir_ref{'support'}, 1, 2 );
        }
        default { warn hostname }
    }

}

## Symbolic Link Opera [Next] Mail Signatures from Dropbox
## Arguments
# $dropbox     : Opera Directory in Dropbox
# $dir_support : Application Suppport Directory of Opera [Next]
# @numbers     : Numbers of Mail Account
sub ln_signature {
    my ( $dropbox, $dir_support, @numbers ) = @_;

    my @db_sig = map { catfile $dropbox, 'mail', "signature$_.txt" } 0 .. 2;

    my $i;
    for (@numbers) {
        smartln(
            'ln',
            $db_sig[ ++$i ],
            catfile( $dir_support, 'mail', "signature$_.txt" )
        );
    }
}

## Copy Opera [Next] Setting Files to Dropbox
## Arguments
# $dropbox          : Opera Directory in Dropbox
# $dir_ref          : (Reference of) Directories of Opera [Next]
# $backup_files_ref : (Reference of) Backup (= Copy) Files for Each Directory
sub backup {
    my ( $dropbox, $dir_ref, $backup_files_ref ) = @_;

    for my $dir_type (qw( library support )) {
        for my $file ( @{ $backup_files_ref->{$dir_type} } ) {
            # smartln( 'cp', "$$dir_ref{$dir_type}/$file", "$dropbox/$file" );
            smartln(
                'cp',
                catfile( $$dir_ref{$dir_type}, $file ),
                catfile( $dropbox,             $file )
            );
        }
    }
}
