use strict;
use warnings;


# 環境設定
# 環境によって異なる定数の定義
# パス文字列など
package Environment;
use Exporter 'import';
our @EXPORT = qw(DB_HOST DB_NAME DB_USER DB_PASS DAV_ROOT_DIR
  GIT_ROOT_DIR SVN_ROOT_DIR TYPETALK_NOTICE_URL
  DEVMODE);

# スクリプト実行時に--devオプションをつけるとlocalhostを指す開発用モードになる
my $devMode = 0;
for my $a (@ARGV) {
  if ($a eq '--dev') {
    $devMode = 1;
  }
}


# Constants definition
use constant {
  DB_NAME => 'backlog',
  # ローカルで開発するときも同じ名前のユーザをつくると便利
  DB_USER => 'select_user',
  DB_PASS => 'support',
};

sub TYPETALK_NOTICE_URL {
  return $devMode
    ? 'https://typetalk.in/api/v1/topics/21341?typetalkToken=dbJdG6o29EDzauflyOZj5HRpn2jAQaalVZYboIjK3bTpzGHlD3ppXnmyxgHmdq92'
    : 'https://typetalk.in/api/v1/topics/24?typetalkToken=7pcrUxHttvItHUAHDjl3ZGCTJSI54qQ13oaBCi7MPycv83GAbEcBKM2auoGaZNBv';
}

sub DB_HOST {
  return ($devMode ? 'localhost' : 'db-slave');
}
sub DAV_ROOT_DIR {
  return ($devMode ? $ENV{"HOME"} . '/data/share/' : '/data/share/');
}
sub GIT_ROOT_DIR {
  return ($devMode ? $ENV{"HOME"} . '/data/git/' : '/data/git/');
}
sub SVN_ROOT_DIR {
  return ($devMode ? $ENV{"HOME"} . '/data/svn/' : '/data/svn/');
}

sub DEVMODE {
  return $devMode;
}

1;
