#!/usr/bin/env ruby
require "rubygems"
require "twitter"
require "google_chart"

client = Twitter::REST::Client.new do |config|
  config.consumer_key        = "XXXX"
  config.consumer_secret     = "XXXX"
  config.access_token        = "XXXX"
  config.access_token_secret = "XXXX"
end

followers = Hash.new(25)
names = ARGV[0...2]

names.each do |name|
  followers[name] = client.follower_ids(name).take(25)
end

my_file = File.new('graph_small.dot', 'w')

my_file.puts 'digraph followers {'
my_file.puts '  node [ fontname=Arial, fontsize=10, penwidth=4 ]'

names.each_with_index do |user, i|
  names[(i + 1)..-1].each do |other_user|
    common_followers = client.users(followers[user] & followers[other_user])
    common_followers.each do |follower|
      my_file.puts %Q{"#{ follower.screen_name }" [style = "filled", color = "black", fillcolor = "red"]}
    end
  end
end

names.each do |name|
  my_file.puts %Q{  "#{ names[0] }" -> "#{ name }"}
  users = client.users(followers[name])
  users.each do |user|
    my_file.puts %Q{    "#{ name }"  ->  "#{ user.screen_name }"}
  end
end

my_file.puts '}'
