
require "rubygems"
require "sinatra"
require 'uuid'
require 'ftools'
require 'xml_types'
require "sequel"

require "pp"

set :app_file, __FILE__
set :reload, false
set :lock, false

DB=Sequel.sqlite("database.db")

if !DB.table_exists? :files
    DB.create_table :files do
        varchar :fid
        varchar :name
        varchar :description
        varchar :path
    end
end

FILES=DB[:files]

IMAGE_DIR='images'

uuid=UUID.new

get '/' do
    xml="<files>"
    file=XML_TYPES::File.new
    FILES.each do |f|
        file.fid=f[:fid]
        file.name=f[:name]
        file.description=f[:description]
        xml<<file.to_xml
    end
    xml<<"</files>"
    xml
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
    
    FILES<<{
        :fid => fid,
        :name => xml_file.name,
        :description => xml_file.description,
        :path => IMAGE_DIR+"/"+fid
    }
    
    xml_file.to_xml
end

put '/' do
    pp params
end

