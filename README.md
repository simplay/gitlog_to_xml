# Gitlog To XML

Extract the logs of googlesource git repositories.

This project contains two auxiliary ruby scripts `source_extractor` and `xml_generator`.
The former script responsible for cloning the target googlesource repositories whereas the latter generates xml files of the cloned repositories containing the git log.

## Requirements

+ curl (`sudo apt-get install curl`)
+ git (`sudo apt-get install git`)
+ ruby (`sudo apt-get install ruby`)

## Usage

First _clone your target repositories_ (**1**) and then _generate the xml_ file (**2**). Please do not forget to re-run the xml generator script after you have invoked the source extractor script.

### (1) Clone repositories [source_extractor.rb]

Cloned repositores are saved to `./repos/`

+ Clone all repositories: `ruby source_extractor.rb`
+ Clone all repositires matching a given pattern: `ruby source_extractor.rb -p PATTERN`
 + example: `ruby source_extractor.rb -p device/asus` clones 7 Asus subprojects.
+ Clone the first N repositories: `ruby source_extractor.rb -f N`
+ Clone all repositories between the i-th and j-th repository entry within the googelsource repository list: `ruby source_extractor.rb -r i j`
 + example: `ruby source_extractor.rb -r 1 100` download all repositories from the first repository until (and with) the 100th repository.
+ Clone a repository by uri: `ruby source_extractor.rb -n URI`
 + example: `ruby source_extractor.rb -n https://github.com/simplay/daily_quests` clones the given github source.

### (2) Generate xml files [xml_generator.rb]

To generate the xml files, run: `ruby xml_generator.rb`
Generated xml files are named after their corresponding repository directory name (see `./repos/`)
and are stored in `./out/`. This command will use the most recent branch (accordinging to the newest commit).

To generate the xml files, run: `ruby xml_generator.rb SOMETHING` using the master branch.

example: `ruby xml_generator.rb 1`
