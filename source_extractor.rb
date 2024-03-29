#!/usr/bin/env ruby

selection_type = ARGV[0]

should_download_page = true
if Dir["./html.txt"].count > 0
  print "The googlesource `html.txt` file already exists. Do you want to redownload it [y/n]? "
  should_download_page = STDIN.gets.chomp.downcase.eql?("y")
end

if should_download_page
  system("curl https://android.googlesource.com/ > html.txt")
end

html_file = File.open("html.txt", "r")
contents = html_file.read
repo_link_div = contents.split("class=\"RepoList\"").last

repo_identifiers = repo_link_div.split("RepoList-itemName")
repo_identifiers = repo_identifiers[2..-1]
repo_identifiers = repo_identifiers.map do |identifier| 
  identifier.split(">")[1].split("<").first 
end

use_default_nameing_schemes = true
status_msg = "Cloning "
info = "(all)"
unless selection_type.nil?
  arg = ARGV[1]
  raise "No argument provided" if arg.nil?

  case selection_type
  when "-n"
    repo_identifiers = [arg]
    use_default_nameing_schemes = false
  when "-p"
    info = "matching the pattern `#{arg}`"
    repo_identifiers = repo_identifiers.select do |item| 
      item.include? arg 
    end
  when "-f"
    info = "(fetching the first #{arg} repo(s).)"
    repo_identifiers = repo_identifiers[0..(arg.to_i-1)] 
  when "-r"
    endix = ARGV[2]
    raise "No till index provided." if endix.nil?
    info = "(fetching the the repos [#{arg},#{endix}]repo(s))"
    repo_identifiers = repo_identifiers[(arg.to_i-1)..(endix.to_i-1)] 
  else
    raise "Unknown parameter #{selection_type}"
  end
end

status = "#{status_msg} #{repo_identifiers.count} repositories #{info}"
puts status
print "Do you want to proceed [y/n]? "
user_input = STDIN.gets.chomp
if (user_input.downcase.eql? 'y')

  # fetch repos here
  uri = (use_default_nameing_schemes)? "https://android.googlesource.com/" : ""
  
  repo_identifiers.each do |repo_identifier|
    system("cd ./repos/ && git clone #{uri}#{repo_identifier}")
    dir_name = repo_identifier.split("/").join("_")
    original_repo_name = repo_identifier.split("/").last
    system("mv ./repos/#{original_repo_name} ./repos/#{dir_name}")
  end
end

