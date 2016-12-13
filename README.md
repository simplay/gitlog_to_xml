# Gitlog To XML

Extract the logs of googlesource git repositories.

This project contains two auxiliary ruby scripts `source_extractor` and `xml_generator`.
The former script responsible for cloning the target googlesource repositories whereas the latter generates xml files of the cloned repositories containing the git log.

## Requirements

+ curl (`sudo apt-get install curl`)
+ git (`sudo apt-get install git`)
+ ruby (`sudo apt-get install ruby`)

## Usage

### Clone repositories

Cloned repositores are saved to `./repos/`

+ Clone all repositories: `ruby source_extractor.rb`
+ Clone all repositires matching a given pattern: `ruby source_extractor.rb -p PATTERN`
 + example: `ruby source_extractor.rb -p device/asus` clones 7 Asus subprojects.
+ Clone the first N repositories: `ruby source_extractor.rb -f N`
+ Clone all repositories between A and B: `ruby source_extractor.rb -r A B`
+ Clone a repository by uri: `ruby source_extractor.rb -n URI`
 + example: `ruby source_extractor.rb -n https://github.com/simplay/daily_quests` clones the given github source.

### Generate xml files

To generate the xml files, run: `ruby xml_generator.rb`
Generated xml files are named after their corresponding repository directory name (see `./repos/`)
and are stored in `./out/`.



