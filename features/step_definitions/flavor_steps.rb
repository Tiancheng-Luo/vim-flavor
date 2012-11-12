require 'fileutils'
require 'tmpdir'

Given /^a temporary directory called '(.+)'$/ do |name|
  path = Dir.mktmpdir
  at_exit do
    FileUtils.remove_entry_secure path
  end
  directory_table[name] = path
end

Given /^a home directory called '(.+)' in '(.+)'$/ do |name, virtual_path|
  actual_path = expand(virtual_path)
  Dir.mkdir actual_path, 0700
  directory_table[name] = actual_path
end

Given /^a repository '(.+)' with versions '(.+)'$/ do |basename, versions|
  repository_path = expand("$tmp/repos/#{basename}")
  system <<-"END"
    {
      mkdir -p '#{repository_path}' &&
      cd '#{repository_path}' &&
      git init &&
      mkdir doc &&
      for v in #{versions}
      do
        echo "*#{basename}* $v" >'doc/#{basename}.txt'
        git add doc
        git commit -m "Version $v"
        git tag -m "Version $v" "$v"
      done
    } >/dev/null
  END
end

Given 'flavorfile' do |content|
  create_file '$tmp/VimFlavor', content
end

Given 'lockfile' do |content|
end

When /^I run vim-flavor with '(.+)'$/ do |args|
end

Then 'I get lockfile' do |content|
end

Then /^I get a bootstrap script in '(.+)'$/ do |virtual_path|
end

Then /^I get flavor '(.+)' with '(.+)' in '(.+)'$/ do |basename, version, virtual_path|
end
