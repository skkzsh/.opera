=head1 NAME

SmartLn - Symbolic Link or Copy Carefully

=head1 SYNOPSIS

    use SmartLn;

    # Symbolic Link from Source to Destination
    smartln('ln', 'source', 'destination1');

    # Copy from Source to Destination
    smartln('cp', 'source', 'destination2');

=head1 DESCRIPTION

Symbolic Link or Copy Carefully

=cut

package SmartLn;
our @EXPORT    = qw( smartln );
our @EXPORT_OK = qw();
use parent qw( Exporter );

use strict;
use warnings;
use 5.010;

use Carp qw( verbose croak carp );
use Pod::Usage qw( pod2usage );
use Pod::Find qw( pod_where );

use Term::UI;
use Term::ReadLine;

## use File::Copy qw( copy );
use File::Copy::Recursive qw( rcopy );
## use File::Path qw( rmtree );


## Symbolic Link or Copy Carefully
## Arguments
# $cmd : ln or cp
# $src : Source
# $dst : Destination
sub smartln {
    my ( $cmd, $src, $dst ) = @_;

    ### TODO
    ### Exception Handling
    eval {
        croak 'Error: No. of arguments must be 3.'
            unless @_ == 3;
        croak "Error: Invalid Option $cmd"
            unless "$cmd" eq 'ln' or "$cmd" eq 'cp';
        croak "Error: Source $src not exists."
            unless -e "$src";
    };
    if ($@) {
        print $@;
        pod2usage( -input => pod_where( { -inc => 1 }, __PACKAGE__ ) );
        return;
    }

    &smartrm($dst);
    &symlink_or_copy( $cmd, $src, $dst );
}

## Request Confirmation Before Attempting to Remove $file
## If $file Exists
sub smartrm {
    my $file = shift;

    if ( -l $file or -f $file or -d $file ) {
        ### Request Confirmation Before Attempting to Remove $file
        my $term          = Term::ReadLine->new('unlink');
        my $unlink_or_not = $term->ask_yn(
            prompt  => "Remove $file ?",
            default => 'y',
        );

        if ($unlink_or_not) {
            if ( -l $file or -f $file ) {
                unlink $file
                    and say 'Removed';
            }
            elsif ( -d $file ) {
                ### TODO: Remove Directory
                ## rmtree "$file"
                rmdir $file
                    and say 'Removed';
            }
            ## and say "Removed";
        }
        else {
            say 'Not Removed';
        }
    }

    else {
        say "Announce    : Try to remove $file, but not exists.";
    }

}

## Symbolic Link or Copy from $src to $dst
## ($cmd = ln or cp)
sub symlink_or_copy {
    my ( $cmd, $src, $dst ) = @_;

    if ( -e $dst ) {
        carp "Announce: $dst exists, so not make link.";
    }
    elsif ( $cmd eq 'ln' ) {
        &symlink_wrapper( $src, $dst );
    }
    elsif ( $cmd eq 'cp' ) {
        rcopy $src, $dst
            and say 'Copied';
    }
    else {
        croak "Error: Invalid Option $cmd";
    }
}

## Switch Symbolic Link Command on Win and UNIX
sub symlink_wrapper {
    my ( $src, $dst ) = @_;

    ## TODO: system Function
    if ( $^O eq 'MSWin32' ) {
        if ( -d $src ) {
            system qq( MKLINK /D "$dst" "$src" );
        }
        else {
            system qq( MKLINK "$dst" "$src" );
        }
    }

    else {
        symlink $src, $dst
            and say 'New Linked';
    }
}

1;
__END__
