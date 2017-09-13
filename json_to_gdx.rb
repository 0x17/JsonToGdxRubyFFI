
require 'ffi'

module JsonToGdx
  extend FFI::Library

  ffi_lib '/media/sf_Dropbox/Arbeit/Code/JsonToGdx/cmake-build-debug/libJsonToGdxLib.so'

  attach_function :set_gams_directories, 'setGAMSDirectories', %i[string string], :void
  attach_function :write_json_str_to_gdx_file, 'writeJsonStrToGdxFile', %i[string string], :void
  attach_function :solve_model_with_data_json_str, 'solveModelWithDataJsonStr', %i[string string string], :string

  def self.write_obj_to_gdx_file(obj, gdxfn)
    write_json_str_to_gdx_file(JSON.generate(obj), gdxfn)
  end
  
  def self.solve_model_with_data_obj(modelcode, gdxfn, obj)
    return solve_model_with_data_json_str(modelcode, gdxfn, JSON.generate(obj))
  end
end
