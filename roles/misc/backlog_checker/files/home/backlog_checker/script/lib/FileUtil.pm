use strict;
use warnings;

package FileUtil;

use Data::Dumper;
use File::Basename;

# ディレクトリ直下にあるファイル名のハッシュセットのリファレンスを返す
sub dirs {
  my ($dir, $matcher) = @_;
  my %ret = ();
  if (-d $dir) {
    opendir(DIR, $dir) or die("Failed to open dir:$dir");
    my @list = readdir(DIR);
    closedir(DIR);
    for my $f (@list) {
      if ($f =~ /^\.{1,2}$/) {
        next;
      } elsif ($matcher) {
        my $m = $matcher->($f, $dir);
        if (!$m) {
          next;
        } elsif ($m eq 1) {
          $ret{$f} = $f;
        } else {
          $ret{$m} = $m;
        }
      } elsif (-d "$dir/$f") {
        $ret{$f} = $f;
      }
    }
  }
  return \%ret;
}


sub join {
  my $ret = '';
  for my $e (@_) {
    if (!$ret) {
      $ret = $e;
    } else {
      $ret =~ s/\/+$//;
      $e =~ s/^\/+//;
      $ret .= '/' . $e;
    }
  }
  return $ret;
}

# ディレクトリ以下の全てのファイル、ディレクトリを再帰的に辿ってコールバックを実行する
# コールバック関数($dir, $file)
# $dir/$file がディレクトリでコールバック関数が0を返すとき、それ以上子孫をたどらない。
sub find {
  my ($dir, $callback) = @_;
  if (-d $dir) {
    opendir(DIR, $dir) or die("Failed to open dir:$dir");
    my @files = readdir(DIR);
    closedir(DIR);
    for my $file (@files) {
      if ($file eq '.' || $file eq '..') {
        next;
      }
      my $path = FileUtil::join($dir, $file);
      my $isDir = -d $path;
      my $r = $callback->($dir, $file, $path, $isDir);
      if ($isDir && $r) {
        find($path, $callback);
      }
    }
  }
}


# 指定されたディレクトリを再帰的に作る
sub mkdir_r {
  my ($dir) = @_;
  if ($dir && !-d $dir) {
    mkdir_r(dirname($dir));
    mkdir($dir);
  }
}

# 指定されたファイル名の親ディレクトリを作る
sub mkParentDir {
  my ($fileName) = @_;
  if ($fileName) {
    my $dir = dirname($fileName);
    mkdir_r($dir);
    return $dir;
  } else {
    return '';
  }
}

1;
