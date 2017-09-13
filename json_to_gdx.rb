
require 'ffi'

module JsonToGdx
  extend FFI::Library

  ffi_lib '/media/sf_Dropbox/Arbeit/Code/JsonToGdx/cmake-build-debug/libJsonToGdxLib.so'

  attach_function :set_gams_directories, 'setGAMSDirectories', %i[string string], :void
  attach_function :write_json_str_to_gdx_file, 'writeJsonStrToGdxFile', %i[string string], :void

  def self.write_obj_to_gdx_file(obj, gdxfn)
    write_json_str_to_gdx_file(JSON.generate(obj), gdxfn)
  end
end
