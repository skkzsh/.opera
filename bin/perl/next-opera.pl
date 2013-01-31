#!/usr/bin/env perl

=head1 DESCRIPTION

Make Symbolic Links or Copy Setting Files
in order to Share Opera Settings with Opera Next ones

=cut

use strict;
use warnings;
use 5.010;

use Path::Class qw( file dir );

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

my %dir = &where_are_dirs();
&setup( \%dir, \%setup_files );

### Outputs : Opera and Opera Next Directories (%dir)
# %dir{'red'}{''}     : Opera Directories
# %dir{'white'}{''}   : Opera Next Directies
# %dir{''}{'library'} :
# %dir{''}{'support'} :
sub where_are_dirs {
    my %dir;

    given ($^O) {

        ### Linux
        when ('linux') {
            $dir{'red'}{'library'} = $dir{'red'}{'support'}
                = dir $ENV{HOME}, '.opera';
            $dir{'white'}{'library'} = $dir{'white'}{'support'}
                = dir $ENV{HOME}, '.opera-next';
        }

        when (/^(darwin|MSWin32)$/) {
            my $red   = 'Opera';
            my $white = 'Opera Next';
            # my $white = 'Opera Labs SPDY';

            my ( $library, $support );
            given ($^O) {
                ### Mac
                when ('darwin') {
                    $library
                        = dir $ENV{HOME}, 'Library';
                    $support
                        = dir $ENV{HOME}, 'Library', 'Application Support';
                }
                ### Win
                when ('MSWin32') {
                    $library = dir $ENV{APPDATA}, 'Opera';
                    $support = dir $ENV{LOCALAPPDATA}, 'Opera';
                }
                default { die $^O }
            }

            $dir{'red'}{'library'}   = dir $library, $red;
            $dir{'red'}{'support'}   = dir $support, $red;
            $dir{'white'}{'library'} = dir $library, $white;
            $dir{'white'}{'support'} = dir $support, $white;

        }

        default { die $^O }
    }

    ### Die if Directories NOT Exist
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

    ## TODO: Keys, Values
    for my $dir_type (qw( library support )) {
        for my $cmd (qw( ln cp )) {
            for my $file ( @{ $setup_files_ref->{$dir_type}{$cmd} } ) {
                smartln(
                    $cmd,
                    file( $$dir_ref{'red'}{$dir_type},   $file ),
                    file( $$dir_ref{'white'}{$dir_type}, $file )
                );
            }
        }
    }

}
