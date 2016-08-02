#!/usr/bin/env ruby
require 'rubygems'
require 'twitter'
require 'google_chart'
require 'time'

def client
  @client ||= set_client(creds.first)
end

def creds
  @creds ||= [
    {
      consumer_key: 'XXXX',
      consumer_secret: 'XXXX',
      access_token: 'XXXX',
      access_token_secret: 'XXXX',
      last_access_at: nil
    },
    {
      consumer_key: 'XXXX',
      consumer_secret: 'XXXX',
      access_token: 'XXXX',
      access_token_secret: 'XXXX',
      last_access_at: nil
    },
    {
      consumer_key: 'XXXX',
      consumer_secret: 'XXXX',
      access_token: 'XXXX',
      access_token_secret: 'XXXX',
      last_access_at: nil
    },
    {
      consumer_key: 'XXXX',
      consumer_secret: 'XXXX',
      access_token: 'XXXX',
      access_token_secret: 'XXXX',
      last_access_at: nil
    }
  ]
end

def set_client(cred)
  cred[:last_access_at] = Time.now
  Twitter::REST::Client.new do |config|
    config.consumer_key        = cred[:consumer_key]
    config.consumer_secret     = cred[:consumer_secret]
    config.access_token        = cred[:access_token]
    config.access_token_secret = cred[:access_token_secret]
  end
end

def with_too_many_requests_handler(name)
  begin
    yield
  rescue Twitter::Error::TooManyRequests
    puts "I am at: #{name}"
    credential = creds.detect { |cred| cred[:last_access_at].nil? }
    if credential
      puts "No waiting"
      @client = set_client(credential)
    else
      firstly_used = creds.collect { |cred| cred[:last_access_at] }.min
      waiting_time = (firstly_used - (Time.now - (60 * 15))).to_i + 1
      if waiting_time > 0
        puts "waiting for #{waiting_time}(s), started at: #{Time.now}"
        sleep(waiting_time)
      else
        puts "No waiting"
        cred = creds.detect { |cred| cred[:last_access_at] == firstly_used }
        cred[:last_access_at] = nil
        @client = set_client(cred)
      end
    end
    retry
  end
end


followers = Hash.new(50)
names = ARGV[0..9]
names.each do |name|
  with_too_many_requests_handler(name) do
    followers[name] = client.followers(name).lazy.first(200)
  end
end

my_file = File.new('graph.dot', 'w')

my_file.puts 'digraph followers {'
my_file.puts '  node [ fontname=Arial, fontsize=10, penwidth=4 ]'

names.each_with_index do |user, i|
  names[(i + 1)..-1].each do |other_user|
    common_followers = followers[user] & followers[other_user]
    common_followers.each do |follower|
      my_file.puts %Q{"#{ follower.screen_name }" [style = "filled", color = "black", fillcolor = "red"]}
    end
  end
end

names.each do |name|
  my_file.puts %Q{  "#{ names[0] }" -> "#{ name }"}
  followers[name].each do |user|
    my_file.puts %Q{    "#{ name }"  ->  "#{ user.screen_name }"}
  end
end

my_file.puts '}'
