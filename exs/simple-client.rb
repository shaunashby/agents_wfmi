#!/usr/bin/env ruby
#____________________________________________________________________
# File: simple-client.rb
#____________________________________________________________________
#
# Author: Shaun Ashby <shaun@ashby.ch>
# Created: 2017-05-04 21:40:06+0200 (Time-stamp: <2017-05-04 22:52:29 sashby>)
# Revision: $Id$
# Description: Simplest test to get a message from a queue
#
# Copyright (C) 2017 Shaun Ashby
#
#
#--------------------------------------------------------------------

require 'bunny'

EXCHG_NAME = 'syncer'
QUEUE_NAME = 'account'

USER = 'guest'
PASSWD = 'guest'
VHOST = '/applisync'
PORT = '32771'
HOST = 'localhost'

begin
  connection = Bunny.new(:host      => HOST, :port      => PORT,
                         :user      => USER,
                         :password  => PASSWD,
                         :vhost     => VHOST,
                         :log_level => Logger::INFO)
  connection.start

  # Check that the exchange exists:
  if connection.exchange_exists?(EXCHG_NAME)
    puts "- Exchange \"#{EXCHG_NAME}\" exists."
  end

  # Check to see if the queuee exists:
  if connection.queue_exists?(QUEUE_NAME)
    puts "- Queue \"#{QUEUE_NAME}\" exists."
    puts "  Connecting.."
    ch = connection.create_channel
    q  = ch.queue(QUEUE_NAME, :durable => true)
    # Publish a message:
    q.publish("I am connected")
    # Check messages:
    delivery_info, meta, payload = q.pop
    puts "\n>> METADATA      : #{meta.inspect}"
    puts "\n>> DELIVERY_INFO : #{delivery_info.inspect}"
    puts "\n== Got message : #{payload}\n"
  end

  # Close it down:
  connection.close()
rescue ArgumentError => err
  puts "Got an error: #{err}"
end
