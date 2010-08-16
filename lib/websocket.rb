#!/usr/bin/env ruby

require "rubygems"
require "em-websocket"
require "yaml"
require "fileutils"

# usage = "websocket.rb [start | stop | restart]"

# riat_websocket_root_dir = File.open('/tmp/riat_websocket_root_dir.txt' ).read
riat_websocket_root_dir = FileUtils.pwd

EventMachine.run {
  # EventMachine::WebSocket.stop if ARGV[0] == "stop"
  puts riat_websocket_root_dir
  EventMachine::WebSocket.start(:host => "0.0.0.0", :port => 5000) do |ws|
      ws.onopen {
        puts "WebSocket connection open"
        
        # publish message to the client
        ws.send "Hello Client - Click submit to start the Impact analysis"
      }

      ws.onclose { puts "Connection closed" }
      ws.onmessage { |msg|
        puts msg
        if msg == nil or msg == ''
          ws.send "<div class='error'>Please provide bounding coordinates e.g: [106,-7.5,110,-3]</div>"
        else
          bbox = msg.delete("[").delete("]").split(",").collect{|v| v.to_f }
          coordstr = bbox.join("_")
          timestamp = Time.now.strftime('%Y%m%d%H%M%S')
          geoserver_url = YAML.load_file("#{riat_websocket_root_dir}/./config/geoserver.yml")['host']
          system "python #{riat_websocket_root_dir}/./lib/riat_python_api/run_impact_model.py \
            bbox=#{msg} \
            timestamp=#{timestamp}"
          layername = "impact:earthquake_fatalities_1hz10pc50_#{timestamp}"
          ws.send "
          <br/>
          <h3>New Impact Results</h3>
          <p>
            <strong>Timestamp:</strong>     #{timestamp}<br/>
            <strong>Layer name:</strong>     #{layername}<br/>
            <strong>Bounding box::</strong> #{msg}<br/>
            
            <img border=\"0\" src='/images/Google-Earth-32.png'/>
            <a href=\"http://#{geoserver_url}/geoserver/wms/kml?layers=#{layername}&legend=true\">
              View impact in Google Earth
            </a>            
          </p>"          
        end
      }
  end
}
