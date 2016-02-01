use strict;
use warnings;

package HashUtil;

use Data::Dumper;


# ハッシュの配列から特定のキーだけ抜き出したハッシュセットのリファレンスを返す
sub flatten {
  my ($key, @list) = @_;
  my %ret = ();
  for my $record (@list) {
    my $v = $record->{$key};
    $ret{$v} = $v;
  }
  return \%ret;
}

sub toSet {
  my %ret = ();
  for my $e (@_) {
    $ret{$e} = $e;
  }
  return \%ret;
}

# ハッシュセットのリファレンスを受け取り差分を返す
# @return 第1引数に入っていて第2引数に入っていない要素の配列
sub diffSets {
  my ($refhash1, $refhash2) = @_;
  my %hash1 = %$refhash1;
  my %hash2 = %$refhash2;

  my @ret = ();
  while (my ($k, $v) = each(%hash1)) {
    if (!$hash2{$k}) {
      push(@ret, $k);
    }
  }

  # print "hash1 = ";
  # print Dumper %hash1;
  #
  # print "hash2 = ";
  # print Dumper %hash2;
  #
  # print "diff = ";
  # print Dumper @ret;
  return @ret;
}

1;
