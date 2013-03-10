#!/usr/bin/env perl

=head1 DESCRIPTION

=head2 Setup Mode

Make Symbolic Links or Copy
Opera [Next] Setting Files
from Dropbox or Repository

=head2 Backup Mode

Copy
Opera [Next] Setting Files
to Dropbox or Repository

=cut

use strict;
use warnings;
use 5.010;

use Sys::Hostname qw( hostname );
use Path::Class qw( file dir );

use SmartLn qw( smartln );

### Setup or Backup
my $mode;
$mode = 'setup';
# $mode = 'backup';

### Opera or Opera Next
my $color;
$color = 'red';
# $color = 'white';
# $color = 'spdy';

### Make Symbolic Links or Copy Files for Each Directory
## TODO: Skin Toolbar
## FIXME: Hash
my @ln_library_files = qw( keyboard mouse );
my @ln_support_files;
my @cp_library_files = qw( toolbar override.ini search.ini );
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

## Opera Directory in Dropbox or Repository
my $prefix;
if ( $^O eq 'MSWin32' ) {
    $prefix = $ENV{USERPROFILE};
}
else {
    $prefix = $ENV{HOME};
}
my $dropbox = dir $prefix, 'Dropbox', 'setting', '.opera';
my $repos = dir $prefix, 'Repository', 'bitbucket', 'unix_files', '.opera';

given ($color) {
    when ('red')   { print 'Opera ' }
    when ('white') { print 'Opera Next ' }
    when ('spdy')  { print 'Opera Labs SPDY ' }
    default        { die $color }
}
my %dir = &where_are_dirs($color);

given ($mode) {
    when ('setup') {
        say 'Setup!';
        &setup( $repos, \%dir, \%setup_files );
    }
    when ('backup') {
        say 'Backup!';
        &backup( $repos, \%dir, \%backup_files );
    }
    default { die $mode }
}

## Outputs : Opera [Next] Directories (%dir)
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
                when ('red')   { $dir{'library'} = dir $ENV{HOME}, '.opera' }
                when ('white') { $dir{'library'} = dir $ENV{HOME}, '.opera-next' }
                default        { die $color }
            }
            $dir{'support'} = $dir{'library'};
        }

        when (/^(darwin|MSWin32)$/) {
            my $color_dir;
            given ($color) {
                when ('red')   { $color_dir = 'Opera' }
                when ('white') { $color_dir = 'Opera Next' }
                when ('spdy')  { $color_dir = 'Opera Labs SPDY' }
                default        { die $color }
            }

            given ($^O) {
                ### Mac
                when ('darwin') {
                    $dir{'library'}
                        = dir $ENV{HOME}, 'Library', $color_dir;
                    $dir{'support'}
                        = dir $ENV{HOME}, 'Library', 'Application Support', $color_dir;
                }
                ### Win
                when ('MSWin32') {
                    $dir{'library'}
                        = dir $ENV{APPDATA}, 'Opera', $color_dir;
                    $dir{'support'}
                        = dir $ENV{LOCALAPPDATA}, 'Opera', $color_dir;
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

## Make Symbolic Links or Copy Opera [Next] Setting Files from Dropbox or Repository
## Arguments
# $repos         : Opera Directory in Repository
# $dir_ref         : (Reference of) Directories of Opera [Next]
# $setup_files_ref : (Reference of) Symbolic Link and Copy Files for Each Directory
sub setup {
    my ( $repos, $dir_ref, $setup_files_ref ) = @_;

    ## TODO: Keys, Values
    for my $dir_type (qw( library support )) {
        for my $cmd (qw( ln cp )) {
            for my $file ( @{ $setup_files_ref->{$dir_type}{$cmd} } ) {
                smartln(
                    $cmd,
                    file( $repos,               $file ),
                    file( $$dir_ref{$dir_type}, $file )
                );
            }
        }
    }

    ### Mail Signaure
    ### TODO: まとめる
    given (hostname) {
        when (/^(sing|box)/) {
            &ln_signature( $repos, $$dir_ref{'support'}, 1, 2 );
        }
        default { warn hostname }
    }

}

## Make Symbolic Links of Opera [Next] Mail Signatures from Dropbox or Repository
## Arguments
# $repos        : Opera Directory in Repository
# $dir_support : Application Suppport Directory of Opera [Next]
# @num         : Numbers of Mail Accounts
sub ln_signature {
    my ( $repos, $dir_support, @num ) = @_;

    for ( 1 .. 2 ) {
        smartln(
            'ln',
            file( $repos,     'mail', "signature$_.txt" ),
            file( $dir_support, 'mail', "signature$num[$_ - 1].txt" )
        );
    }
}

## Copy Opera [Next] Setting Files to Dropbox or Repository
## Arguments
# $repos             : Opera Directory in Repository
# $dir_ref          : (Reference of) Directories of Opera [Next]
# $backup_files_ref : (Reference of) Copy Files for Each Directory
sub backup {
    my ( $repos, $dir_ref, $backup_files_ref ) = @_;

    ## TODO: Keys, Values
    for my $dir_type (qw( library support )) {
        for my $file ( @{ $backup_files_ref->{$dir_type} } ) {
            smartln(
                'cp',
                file( $$dir_ref{$dir_type}, $file ),
                file( $repos,               $file )
            );
        }
    }
}
