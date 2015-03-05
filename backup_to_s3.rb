#!/usr/bin/env ruby

# How to set crontab
#
# $ crontab -e;
# 0 9 * * * ruby /home/XXXXXXXXXXXXX/MySQL_backup/backup_to_s3.rb 2>&1 | logger -t backup_to_s3.rb

# -*- coding: utf-8 -*-
require 'rubygems'
require 'aws/s3'
include AWS::S3

bucket = 'mysql-backup-xxxxxxxxx'
host = `hostname`.strip

Base.establish_connection!(
  :access_key_id => 'XXXXXXXXXXXXXXXXX',
  :secret_access_key => 'XXXXXXXXXXXXXXX'
)
AWS::S3::DEFAULT_HOST.replace "s3-ap-northeast-1.amazonaws.com"

today = Time.now.strftime("%Y%m%d")

Dir::glob("/home/XXXXXXXXXXXXX/MySQL_backup/#{today}/*").each {|f|
  puts f
  S3Object.store(
    File.basename(f),
    open(f),
    "#{bucket}/#{host}/#{today}"
  )
}

#
