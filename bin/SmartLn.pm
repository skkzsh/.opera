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
use base qw( Exporter );

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

### TODO: Write Properly Exception Handling and Comment

## Symbolic Link or Copy Carefully
## Arguments
# $cmd : ln or cp
# $src : Source
# $dst : Destination
sub smartln {
    my ( $cmd, $src, $dst ) = @_;

    ### Exception Handling
    eval {
        croak "Error: No. of arguments must be 3."
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

    &rm_dst($dst);
    &link( $cmd, $src, $dst );
}

## Link先 ($dst) が存在すれば
## 削除するか尋ねて，実行
sub rm_dst {
    my $dst = shift;

    if ( -l "$dst" or -f "$dst" or -d "$dst" ) {
        ### 削除するか尋ねる
        my $term          = Term::ReadLine->new('unlink');
        my $unlink_or_not = $term->ask_yn(
            prompt  => "Remove $dst ?",
            default => 'y',
        );

        if ($unlink_or_not) {
            if ( -l "$dst" or -f "$dst" ) {
                unlink "$dst"
                    and say "Removed";
            }
            elsif ( -d "$dst" ) {
                ### TODO: Remove Directory
                ## rmtree "$dst"
                rmdir "$dst"
                    and say "Removed";
            }
            ## and say "Removed";
        }
        else {
            say "Not Removed";
        }
    }

    else {
        say "Announce    : Try to remove $dst, but not exists.";
    }

}

## Symbolic Link or Copy from $src to $dst
## ($cmd = ln or cp)
sub link {
    my ( $cmd, $src, $dst ) = @_;

    if ( -e "$dst" ) {
        carp "Announce: $dst exists, so not make link.";
    }
    elsif ( "$cmd" eq 'ln' ) {
        &os_symlink( $src, $dst );
    }
    elsif ( "$cmd" eq 'cp' ) {
        rcopy "$src", "$dst"
            and say "Copied";
    }
    else {
        croak "Error: Invalid Option $cmd";
    }
}

## Switch Symbolic Link Command on Win and UNIX
sub os_symlink {
    my ( $src, $dst ) = @_;

    if ( $^O eq 'MSWin32' ) {
        if ( -d "$src" ) {
            system "MKLINK /D \"$dst\" \"$src\"";
        }
        else {
            system "MKLINK \"$dst\" \"$src\"";
        }
    }

    else {
        symlink "$src", "$dst"
            and say "New Linked";
    }
}

1;
__END__
