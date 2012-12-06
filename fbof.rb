#!/usr/bin/env ruby -wKU

def name_from_facebook_id fbid
  nil
end

def load_page
  nil
end

def extract_line source
  lines = source.split '\n'
  lines.select {|l| l =~ /OrderedFriendsListInitialData/}.first
end

def parse_line friends_line
  friends_line =~ /\["OrderedFriendsListInitialData",\[\],\{"list":\["([\"0-9\,]*)"/
  friends_str = $1
  friends_str.split '","'
end

def extract_friends page_source
  friends_line = extract_line page_source
  parse_line extract_line(page_source)
end

def get_ordered_friend_list
  extract_friends load_page()
end

friend_names = get_ordered_friend_list().map{ |id| name_from_facebook_id id }

friend_names.each_with_index do |friend, index|
  puts "#{index}: #{friend}"
end
