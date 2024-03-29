#!/usr/bin/env ruby -wKU

require 'net/http'
require 'uri'
require 'json'

count = ARGV.last.to_i if ARGV.length > 0
count ||= 10

def extract_line source, search
  lines = source.split '\n'
  lines.select {|l| l =~ search }.first
end

def load_user_page fbid
  user_uri = URI.parse("http://graph.facebook.com/#{fbid}")
  
  Net::HTTP.get_response(user_uri).body
end

def name_from_facebook_id fbid
  page = load_user_page fbid
  
  data = JSON.parse page
  
  data['name']
end

# Load a random page from facebook and return the source
def load_page
  # temporary static data
  File.read("/Users/ben/Desktop/Facebook.html")
end

def parse_line friends_line
  friends_line =~ /\["OrderedFriendsListInitialData",\[\],\{"list":\["([\"0-9\,]*)"/
  friends_str = $1
  friends_str.split '","'
end

def extract_friends page_source
  friends_line = extract_line(page_source, /OrderedFriendsListInitialData/)
  parse_line friends_line
end

def get_ordered_friend_list
  extract_friends load_page()
end

def print_count index, count
  count_width = count.to_s.length
  current = (index + 1).to_s.rjust(count_width)
  print "\rLoading #{current}/#{count}"
end

############# Program flow #############

puts 'Loading friends'
friends = get_ordered_friend_list

friend_count = friends.length

friend_names = friends.each_with_index.map do |id, index| 
  print_count index, friend_count
  name_from_facebook_id id 
end

puts "... Done!"

friend_names.first(count).each_with_index do |friend, index|
  puts "#{index+1}: #{friend}"
end
