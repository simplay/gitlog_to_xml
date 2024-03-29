#!/usr/bin/env ruby
# usage: `ruby parser.rb`
#
# generate an xml file for each repository contained in `./repos/`, containing the git log.
# The coressponding xml files will be put inside `./out`.
out_path = Dir.pwd + "/out/"
repository_sources = Dir["repos/*"]

skip = false
skip = true if ARGV[0]

puts "Extracting logs and saving them to xml files..."
status = (skip) ? "Always using master branch" 
                : "Switching to mast recent branch (according to commits)"
puts status

# @example git_log_cmd_for("kernel_samsung")
# @param project_name [String] name of project
def git_log_cmd_for(project_name)
  process_git_tree_cmd = "git log --pretty=format:\" <change>%n <commit_hash>%H</commit_hash>%n <tree_hash>%T</tree_hash>%n <parent_hashes>%P</parent_hashes>%n <author_name>%an</author_name>%n
  <author_email>%ae</author_email>%n <author_date>%ad</author_date>%n
  <committer_name>%cn</committer_name>%n <committer_email>%ce</committer_email>%n
  <committer_date>%cd</committer_date>%n <project>#{project_name}</project>%n
  <subject>%s</subject>%n </change>\""
end

repository_sources.each do |repo_source|
  repo_name = repo_source.split("/").last
  
  branch_count = `cd ./#{repo_source} && git branch -a --sort=-committerdate | cat | wc -l`
  branch_count = branch_count.chomp.lstrip.to_i
  if (branch_count > 1) && !skip
    most_recent_branch = `cd ./#{repo_source} && git branch -a --sort=-committerdate | cat | head -n 1`
    
    most_recent_branch = most_recent_branch.chomp.lstrip
    most_recent_branch = most_recent_branch.split("/").last
    system("cd ./#{repo_source} && git checkout #{most_recent_branch}")
  end


  open("#{out_path}/#{repo_name}.xml", 'w') do |file|
    file << "<?xml version=\"1.0\"?>\n"
    file << "<changes>\n"
  end
  system("cd ./#{repo_source} && #{git_log_cmd_for(repo_name)} >> #{out_path}/#{repo_name}.xml")
  open("#{out_path}/#{repo_name}.xml", 'a') do |file|
    file << "\n"
    file << "</changes>"
  end
end
