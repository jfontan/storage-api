
require 'HappyMapper'

module XML_TYPES
    class File
        include HappyMapper
        
        element :fid,           String
        element :name,          String
        element :description,   String
        
        def to_xml
            "<file>"+
            "<fid>#{fid}</fid>"+
            "<name>#{name}</name>"+
            "<description>#{description}</description>"+
            "</file>"
        end
    end
end


