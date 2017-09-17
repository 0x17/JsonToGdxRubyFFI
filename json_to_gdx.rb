require 'ffi'

JSON_GDX_LIB_PATH_VM = '/media/sf_Dropbox/Arbeit/Code/JsonToGdx/cmake-build-debug/libJsonToGdxLib.so'
JSON_GDX_LIB_PATH_LINUX = '/home/andre/Dropbox/Arbeit/Code/JsonToGdx/cmake-build-debug/libJsonToGdxLib.so'
JSON_GDX_LIB_PATH_OSX = '/Users/andreschnabel/Dropbox/Arbeit/Code/JsonToGdx/cmake-build-debug/libJsonToGdxLib.dylib'
JSON_GDX_LIB_PATH = if (/darwin/ =~ RUBY_PLATFORM) != nil then JSON_GDX_LIB_PATH_OSX else JSON_GDX_LIB_PATH_VM end

module JsonToGdx
  extend FFI::Library

  ffi_lib JSON_GDX_LIB_PATH

  attach_function :set_gams_directories, 'setGAMSDirectories', %i[string string], :void
  attach_function :write_json_str_to_gdx_file, 'writeJsonStrToGdxFile', %i[string string], :void
  attach_function :solve_model_with_data_json_str, 'solveModelWithDataJsonStr', %i[string string], :string
  attach_function :set_gams_options_json, 'setGAMSOptions', %i[string], :void
  attach_function :read_json_str_from_gdx_file, 'readJsonStrFromGdxFile', %i[string], :string

  def self.write_obj_to_gdx_file(obj, gdxfn)
    write_json_str_to_gdx_file(JSON.generate(obj), gdxfn)
  end
  
  def self.solve_model_with_data_obj(modelcode, obj)
    return JSON.parse(solve_model_with_data_json_str(modelcode, JSON.generate(obj)))
  end

  def self.read_obj_from_gdx_file(gdxfn)
    return JSON.parse(read_json_str_from_gdx_file(gdxfn))
  end

  def self.set_gams_options(obj)
    set_gams_options_json(JSON.generate(obj))
  end
end
