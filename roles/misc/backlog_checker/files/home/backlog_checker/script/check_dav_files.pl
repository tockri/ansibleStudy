#!/usr/bin/env perl
use strict;
use warnings;
use utf8;
use File::Basename;

# ローカルモジュール
use lib dirname(__FILE__) . '/lib';
use DavFileExistCheck;


sub main {
  DavFileExistCheck::checkAll;
}

main;
DBUtil::end;
