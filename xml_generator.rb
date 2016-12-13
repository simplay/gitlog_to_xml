#!/usr/bin/env ruby

# usage: `ruby parser.rb`
#
# generate an xml file for each repository contained in `./repos/`, containing the git log.
# The coressponding xml files will be put inside `./out`.
out_path = Dir.pwd + "/out/"
repository_sources = Dir["repos/*"]

process_git_tree_cmd = "git log --pretty=format:\" <change>%n <author_name>%an</author_name>%n
<author_e_mail>%ae</author_e_mail>%n <author_date>%ad</author_date>%n
<committer_name>%cn</committer_name>%n <committer_email>%ce</committer_email>%n
<committer_date>%cd</committer_date>%n <project>kernel_samsung</project>%n
<subject>%s</subject>%n </change>\""

repository_sources.each do |repo_source|
  repo_name = repo_source.split("/").last
  open("#{out_path}/#{repo_name}.xml", 'w') do |file|
    file << "<?xml version=\"1.0\"?>\n"
    file << "<changes>\n"
  end
  system("cd ./#{repo_source} && #{process_git_tree_cmd} >> #{out_path}/#{repo_name}.xml")
  open("#{out_path}/#{repo_name}.xml", 'a') do |file|
    file << "\n"
    file << "</changes>"
  end
end
