require_relative 'json_to_gdx'
require_relative 'examples'
require 'json'

SYSDIR_LINUX = '/home/andre/Downloads/gams24.9_linux_x64_64_sfx/'
WORKDIR_LINUX = '/home/andre/Desktop/'

SYSDIR_OSX = '/Applications/GAMS24.9/sysdir/'
WORKDIR_OSX = '/Users/andreschnabel/Desktop/'

SYSDIR = if (/darwin/ =~ RUBY_PLATFORM) != nil then SYSDIR_OSX else SYSDIR_LINUX end
WORKDIR = if (/darwin/ =~ RUBY_PLATFORM) != nil then WORKDIR_OSX else WORKDIR_LINUX end

class Main
  def main
    #jss = IO.read('example.json')
    #robj = JSON.parse(jss)
    # JsonToGdx.write_gdx("/Applications/GAMS24.7/sysdir/")
    # JsonToGdx.write_json_str_to_gdx_file(jss, "someruby.gdx")
    # JsonToGdx.print("Test")

    JsonToGdx.set_gams_directories(SYSDIR, WORKDIR)
    # JsonToGdx.write_obj_to_gdx_file({sets: [{name: 'j', from: 1, to: 10}]}, "someotherruby.gdx")
    Examples.knapsack
    #Examples.rcpsp_roc
  end
end

m = Main.new
m.main
