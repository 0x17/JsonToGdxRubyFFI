require_relative 'json_to_gdx'
require_relative 'examples'
require 'json'

class Main
  def main
    #jss = IO.read('example.json')
    #robj = JSON.parse(jss)
    # JsonToGdx.write_gdx("/Applications/GAMS24.7/sysdir/")
    # JsonToGdx.write_json_str_to_gdx_file(jss, "someruby.gdx")
    # JsonToGdx.print("Test")

    JsonToGdx.set_gams_directories('/home/andre/Downloads/gams24.9_linux_x64_64_sfx/', '/home/andre/Desktop/')
    # JsonToGdx.write_obj_to_gdx_file({sets: [{name: 'j', from: 1, to: 10}]}, "someotherruby.gdx")
    Examples.knapsack
    #Examples.rcpsp_roc
  end
end

m = Main.new
m.main
