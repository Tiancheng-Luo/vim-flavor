require 'fileutils'
require 'vim-flavor'

class FakeUserEnvironment
  def create_file path, content
    File.open(path, 'w') do |f|
      f.write(content)
    end
  end

  def delete_path path
    FileUtils.remove_entry_secure(path)
  end

  def expand(virtual_path)
    virtual_path.gsub(/\$([a-z_]+)/) {
      variable_table[$1]
    }
  end

  def make_flavor_path(vimfiles_path, repo_name)
    expand("#{vimfiles_path.to_flavors_path}/#{repo_name.zap}")
  end

  def make_repo_path(basename)
    expand("$tmp/repos/#{basename}")
  end

  def make_repo_uri(basename)
    "file://#{make_repo_path(basename)}"
  end

  def variable_table
    @variable_table ||= Hash.new
  end
end

World do
  FakeUserEnvironment.new
end
