#!/usr/bin/env perl

=head1 DESCRIPTION

Symbolic Link and Copy Setting Files
in order to Share Opera Settings with Opera Next ones

=cut

use strict;
use warnings;
use 5.010;

use File::Spec::Functions qw( catfile );

use SmartLn qw( smartln );

### Symbolic Link and Copy Files for Each Directory
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

### Outputs : Directories of Opera and Opera Next (%dir)
# %dir{'red'}{''}     : OperaのDirectories
# %dir{'white'}{''}   : Opera NextのDirecties
# %dir{''}{'library'} :
# %dir{''}{'support'} :
sub where_are_dirs {
    my %dir;

    given ($^O) {

        ### Linux
        when ('linux') {
            $dir{'red'}{'library'} = $dir{'red'}{'support'}
                = catfile $ENV{HOME}, '.opera';
            $dir{'white'}{'library'} = $dir{'white'}{'support'}
                = catfile $ENV{HOME}, '.opera-next';
        }

        when (/^(darwin|MSWin32)$/) {
            my $red   = 'Opera';
            my $white = 'Opera Next';

            my ( $library, $support );
            given ($^O) {
                ### Mac
                when ('darwin') {
                    $library
                        = catfile $ENV{HOME}, 'Library';
                    $support
                        = catfile $ENV{HOME}, 'Library', 'Application Support';
                }
                ### Win
                ## TODO: WindowsのENVで\を/に変換
                when ('MSWin32') {
                    $library = catfile $ENV{APPDATA}, 'Opera';
                    $support = catfile $ENV{LOCALAPPDATA}, 'Opera';
                }
                default { die $^O }
            }

            $dir{'red'}{'library'}   = catfile $library, $red;
            $dir{'red'}{'support'}   = catfile $support, $red;
            $dir{'white'}{'library'} = catfile $library, $white;
            $dir{'white'}{'support'} = catfile $support, $white;

        }

        default { die $^O }
    }

    ### Die if Directories NOT Exists
    for my $color_ref ( values %dir ) {
        for my $dir ( values %$color_ref ) {
            die "Error: $dir not exists." unless -d $dir;
        }
    }

    %dir;
}

## Symbolic Link and Copy from Opera Files to Opera Next ones.
## Arguments
# $dir_ref         : (Reference of) Directories of Opera and Opera Next
# $setup_files_ref : (Reference of) Symbolic Link and Copy Files for Each Directory
sub setup {
    my ( $dir_ref, $setup_files_ref ) = @_;

    for my $dir_type (qw( library support )) {
        for my $cmd (qw( ln cp )) {
            for my $file ( @{ $setup_files_ref->{$dir_type}{$cmd} } ) {
                smartln(
                    $cmd,
                    catfile( $$dir_ref{'red'}{$dir_type},   $file ),
                    catfile( $$dir_ref{'white'}{$dir_type}, $file )
                );
            }
        }
    }

}
