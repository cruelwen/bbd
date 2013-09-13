$:.unshift(File.dirname(__FILE__))

require 'yaml'
require 'optparse'
require 'rest_client'
require 'json'

require 'common'

class Bbd
  include Common

  attr_reader :buildinfo, :package, :output, :config

  def initialize(args = {})
    @config = read_yaml(args[:config]) if args[:config]
    @buildinfo = read_yaml(args[:buildinfo]) 
    @package = args[:package]
    @output = args[:output]
  end

  def read_yaml(yaml)
    begin
      info = YAML.load_file(yaml)
      log(:info,"Read YAML #{yaml}")
    rescue => e
      log(:error,"Could not read YAML file #{yaml}: #{e}")
      exit 1
    end
    info
  end
  
  def build
    Dir.mkdir(@output)
    Dir.chdir(@output)
    trysh(3,"git clone #{@buildinfo["main"]["source"]}")
    repo = /(.*)\/(.*)$/.match(@buildinfo["main"]["source"].to_s)[2]
    Dir.chdir(repo)
    sh "git checkout #{@buildinfo["tag"]}" if @buildinfo["main"]["tag"]
    sh @buildinfo["main"]["script"] if @buildinfo["main"]["script"]
    sh "tar zcvf ../#{repo}.tar.gz #{@buildinfo["main"]["tar"]}"
    @buildresult = File.join(@output, "#{repo}.tar.gz")
    url = "http://10.36.15.46:8000/upload/resource/#{repo}/1.0.0"
    RestClient.post( url, { :Authorization => 'admin:admin', :upload => {:file => "@buildresult"}})
  end


end


