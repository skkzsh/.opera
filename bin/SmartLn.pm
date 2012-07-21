## 慎重にSymbolic Link/Copyする

use strict;
use warnings;
use 5.010;

use Term::UI;
use Term::ReadLine;

## use File::Copy 'copy';
use File::Copy::Recursive 'rcopy';
## use File::Path 'rmtree';

### TODO: Error処理とかCommentをちゃんと書く

sub smartln {
    my ( $cmd, $src, $dst ) = @_;

    ### 引数が3個でなければ中断する
    ## if ( $# -ne 3 ) {
    ##     die "Error       : No. of arguments must be 3.
    ##     Usage: SmartLn 'ln/cp' 'source' 'destination'">&2
    ##     # exit 1
    ## }

    # if ( $^O eq 'MSWin32' ) {
    #     $src =~ s#\\#/#g;
    #     $dst =~ s#\\#/#g;
    # }

    ### Link元が存在しなければError
    warn "Error       : Source $src not exists." unless -e "$src";

    &rm_dst($dst);
    &link($cmd, $src, $dst);
}

### Link先 ($dst) が存在すれば
### 削除するか尋ねて，実行
sub rm_dst {
    my $dst = shift;

    if ( -l "$dst" or -f "$dst" or -d "$dst" ) {
        ### 削除するか尋ねる
        my $term = Term::ReadLine->new('unlink');
        my $unlink_or_not = $term->ask_yn(
           prompt   => "Remove $dst ?",
           default  => 'y',
        );

        if ($unlink_or_not) {
            if ( -l "$dst" or -f "$dst" ) {
                unlink "$dst"
                    and say "Removed";
            }
            elsif ( -d "$dst" ) {
                ## rmtree "$dst"
                rmdir "$dst"
                    and say "Removed";
            }
            # and say "Removed";
        }
        else {
            say "Not Removed";
        }
    }

    else {
        say "Announce    : Try to remove $dst, but not exists.";
    }

}

### $srcから$dstにSymbolic Link or Copy
### ($cmd = ln or cp)
sub link {
    my ( $cmd, $src, $dst ) = @_;

    if ( -e "$dst" ) {
        warn "Announce    : $dst exists, so not make link.";
    }
    elsif ( "$cmd" eq 'ln' ) {
        &os_symlink($src, $dst);
    }
    elsif ( "$cmd" eq 'cp' ) {
        rcopy "$src", "$dst"
            and say "Copied";
    }
    else {
        warn "Error       : Invalid Option $cmd
        Usage: SmartLn 'ln/cp' 'source' 'destination'";
    }
}

### WinとUNIXでSymbolic LinkのCommandを使い分ける
sub os_symlink {
    my ($src, $dst) = @_;

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
