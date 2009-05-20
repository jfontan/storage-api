
require 'rubygems'
require 'curb'
require 'xml_types'
require 'pp'

MB_DIV=1024*1024

def upload_file(url, metadata, file)
    c = Curl::Easy.new(url)
    
    start_time=Time.now

    c.on_progress {|d_total, d_now, u_total, u_now|
        print " %8.2f Mb / %8.2f Mb | %5.2f %% | %5.2f Mb/s\r" % [
            u_now*1.0/MB_DIV, 
            u_total*1.0/MB_DIV,
            u_now*1.0/u_total*100.0,
            (u_now*1.0/MB_DIV)/(Time.now-start_time).to_i
        ]
        true
    }

    c.multipart_form_post = true
    c.http_post(
        Curl::PostField.content('metadata', metadata),
        Curl::PostField.file('file', file)
    )
    puts
        
    c.body_str
end

#upload_file("http://localhost:4567", '/Users/jfontan/opennebula.tar.gz')


def create_file(name, description, file_name)
    file=XML_TYPES::File.new
    file.name=name
    file.description=description
    upload_file(
        "http://localhost:4567",
        file.to_xml,
        file_name)
end

pp create_file(*ARGV)

