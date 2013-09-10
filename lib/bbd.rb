$:.unshift(File.dirname(__FILE__))

require 'yaml'
require 'optparse'

require 'common'

class Bbd
  include Common

  def initialize(args = {})
    @buildinfo = read_buildinfo(args[:buildinfo])
    @package = args[:package]
    @output = args[:output]
  end

  def read_buildinfo(buildinfo)
    begin
      info = YAML.load_file(buildinfo)
      log(:info,"Read buildinfo #{buildinfo}")
    rescue => e
      log(:error,"Could not read buildinfo file #{buildinfo}: #{e}")
      exit 1
    end
    info
  end
  
  def build
    sh <<HC_BUILD
cd #{@output} && rm -rf *
cd -
cp -rp #{@package}/* #{@output}/
HC_BUILD
  end

end

