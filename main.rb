require_relative 'json_to_gdx'
require 'json'

KS_GAMS_CODE = '
* knapsack.gms

set i objects;

parameters v(i) values
           w(i) weights;

scalar C maximum weight capacity of knapsack;

equations obj objective function
          cap capacity constraint;

variable Z objective value;
binary variable x(i) object i is taken;

obj .. Z =e= sum(i, v(i) * x(i));
cap .. sum(i, w(i) * x(i)) =l= C;

model knapsack /obj, cap/;

$GDXIN knapsack_data.gdx
$LOAD i, v, w, C
$GDXIN

solve knapsack maximizing Z using MIP;
'.freeze

KS_DATA_OBJ = {
  sets: [{ name: 'i', from: 1, to: 4 }],
  parameters: [
    { name: 'v', indices: 'i', values: [1, 2, 3, 4] },
    { name: 'w', indices: 'i', values: [1, 2, 3, 4] }
  ],
  scalars: [{ name: 'C', value: 4 }]
}.freeze

class Main
  def main
    jss = IO.read('example.json')
    robj = JSON.parse(jss)

    # JsonToGdx.write_gdx("/Applications/GAMS24.7/sysdir/")
    # JsonToGdx.write_json_str_to_gdx_file(jss, "someruby.gdx")
    # JsonToGdx.print("Test")

    JsonToGdx.set_gams_directories('/home/andre/Downloads/gams24.9_linux_x64_64_sfx/', '/home/andre/Desktop/')
    # JsonToGdx.write_obj_to_gdx_file({sets: [{name: 'j', from: 1, to: 10}]}, "someotherruby.gdx")
    res = JsonToGdx.solve_model_with_data_obj(KS_GAMS_CODE, 'knapsack_data.gdx', KS_DATA_OBJ)
    puts res
  end
end

m = Main.new
m.main
