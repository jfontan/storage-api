
require "rubygems"
require "sinatra"
require 'uuid'
require 'ftools'
require 'xml_types'
#require "sequel"

require "pp"

IMAGE_DIR='images'

uuid=UUID.new

get '/' do
    'yujuuu'
end

post '/' do
    fid=uuid.generate
    
    file=params["file"]
    
    # tmpfile where the file is stored
    f_tmp=file[:tempfile]
    File.move(f_tmp.path, IMAGE_DIR+"/"+fid)
    f_tmp.unlink
    
    xml_file=XML_TYPES::File.parse(params[:metadata])
    xml_file.fid=fid
    xml_file.to_xml
end

put '/' do
    pp params
end

