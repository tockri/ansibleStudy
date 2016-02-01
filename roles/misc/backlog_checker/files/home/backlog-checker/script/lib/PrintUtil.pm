use strict;
use warnings;

package PrintUtil;

use Data::Dumper;

my $_printListPrefix = '';

sub setPrefix {
  ($_printListPrefix) = @_;
}

sub clearPrefix {
  $_printListPrefix = '';
}

my $_output = *STDOUT;

# 配列をつなげて文字列にする
sub dumpList {
  my ($list) = @_;
  my $ret = "";
  if ($list) {
    for my $e (@$list) {
      $ret .= $_printListPrefix . "$e\n";
    }
  }
  return $ret;
}

# 配列のハッシュをつなげて文字列にする
sub dumpListHash {
  my ($hash) = @_;
  my $ret = '';
  while (my ($k, $v) = each(%$hash)) {
    $_printListPrefix = "$k/";
    $ret = dumpList($v);
  }
  return $ret;
}

# 配列を出力する
sub printList {
  my ($list) = @_;
  if ($list) {
    for my $e (@$list) {
      print $_output $_printListPrefix, "$e\n";
    }
  }
}

# 配列をファイル出力する
# @param file ファイル名
# @param list
sub outputList {
  my ($file, $list) = @_;
  my $out = $_output;
  FileUtil::mkParentDir($file);
  open(F0, ">$file");
  $_output = *F0;
  clearPrefix;
  printList($list);
  close(F0);
  $_output = $out;
}

# 配列のハッシュを出力
sub printListHash {
  my ($hash) = @_;
  my $out = $_output;
  while (my ($k, $v) = each(%$hash)) {
    $_printListPrefix = "$k/";
    printList($v);
  }
  $_output = $out;
}

# 配列のハッシュをファイル出力する
sub outputListHash {
  my ($file, $listHash) = @_;
  my $out = $_output;
  FileUtil::mkParentDir($file);
  open(F0, ">$file");
  $_output = *F0;
  clearPrefix;
  printListHash($listHash);
  close(F0);
  $_output = $out;
}

1;
