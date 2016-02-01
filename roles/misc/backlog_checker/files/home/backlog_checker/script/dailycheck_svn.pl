#!/usr/bin/env perl
use strict;
use warnings;
use utf8;
use File::Basename;

# ローカルモジュール
use lib dirname(__FILE__) . '/lib';
use SvnDirCheck;


sub main {
  SvnDirCheck::dailyCheck;
}

main;
DBUtil::end;
