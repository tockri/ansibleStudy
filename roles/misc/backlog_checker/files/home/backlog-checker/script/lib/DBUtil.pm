use strict;
use warnings;

package DBUtil;

use Environment;
use Data::Dumper;
use DBI;

my $_connection;

# コネクションを返す
sub db {
  if (!$_connection) {
    my $db_host = DB_HOST;
    my $db_name = DB_NAME;
    $_connection = DBI->connect( "dbi:mysql:database=$db_name;host=$db_host",
    DB_USER, DB_PASS, { AutoCommit => 0, RaiseError => 1 } );
    $_connection->do("SET NAMES utf8");
    # print "connected to mysql( $db_host/$db_name ).\n";
  }
  return $_connection;
}

# 終了処理
sub end {
  if ($_connection) {
    $_connection->disconnect;
    $_connection = 0;
    # print "mysql connection closed.\n";
  }
}

sub queryValue {
  my ($sql, @params) = @_;
  my $conn = db;
  my $st = $conn->prepare($sql);
  $st->execute(@params);
  my ($val) = $st->fetchrow_array;
  $st->finish;
  return $val;
}



# 一行fetchして返す
sub queryRecord {
  my ($sql, @params) = @_;
  my $conn = db;
  my $st = $conn->prepare($sql);
  $st->execute(@params);
  my $record = $st->fetchrow_hashref;
  $st->finish;
  return $record;
}

# 一行fetchするごとにコールバック関数を実行する
# コールバック関数では、ループを終了するかどうかの値（続ける場合=1, 終了する場合=0）
# を返す必要がある。
sub queryCallback {
  my ($sql, $callback, @params) = @_;
  my $conn = db;
  my $st = $conn->prepare($sql);
  $st->execute(@params);
  while (my $record = $st->fetchrow_hashref) {
    my $r = $callback->($record);
    if ($r == 0) {
      last;
    }
  }
  $st->finish;
}

# ハッシュの配列を返す
# @param $sql
# @param $params
sub queryList {
  my ($sql, @params) = @_;
  my $conn = db;
  my $st = $conn->prepare($sql);
  $st->execute(@params);
  my @ret = ();
  while (my $record = $st->fetchrow_hashref) {
    push(@ret, $record);
  }
  $st->finish;
  return @ret;
}

# ２重ハッシュのリファレンスを返す。外側のキーはユニークキー。
# @param $sql
# @param $keyColumn ユニークキー
# @param $params
sub queryHash {
  my ($sql, $keyColumn, @params) = @_;
  my $conn = db;
  my $st = $conn->prepare($sql);
  $st->execute(@params);
  my %ret = ();
  while (my $record = $st->fetchrow_hashref) {
    $ret{$record->{$keyColumn}} = $record;
  }
  $st->finish;
  return \%ret;
}


1;
