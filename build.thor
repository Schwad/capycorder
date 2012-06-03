require "rubygems"
require "thor"
require "json"

class Build < Thor::Group
  include Thor::Actions

  class_option :destination, :type => :string, :default => './build'

  def self.source_root
    File.dirname(__FILE__)
  end

  def prepare_dir
    remove_dir destination
    empty_directory destination
  end

  def copy_icons
    copy manifest['icons']
  end

  def copy_content_scripts
    manifest['content_scripts'].each do |scripts|
      copy scripts['css']
      copy scripts['js']
    end
  end

  def copy_web_accessible_resources
    copy manifest['web_accessible_resources']
  end

private

  def copy(list)
    list.each do |k, v|
      file = list.is_a?(Hash) ? v : k
      copy_file file, File.join(destination, file)
    end
  end

  def destination
    options[:destination]
  end

  def manifest
    @manifest ||= JSON.parse(File.read('manifest.json'))
  end

 end