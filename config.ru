require 'zlib'
require 'red_raw'

run(proc do |env|
  request = Rack::Request.new(env)
  response = nil
  
  case request.path_info
    when %r<^/graph\.(.*)$>
      if (content_type = $1) =~ /^(png|gif)$/
        
        mode = 'dot'
        
        input = request.params[mode].strip
      
        unless input.empty?
          begin
            input = RedRaw.decode_url64(input)
            input = Zlib::Inflate.inflate(input)

            case mode
              when 'dot' then
                output = IO.popen("dot -T#{content_type}", 'r+') do |io|
                  io.write(input)
                  io.close_write
                  io.read
                end
            end

            response ||= [200, {'Content-Type' => "image/#{content_type}"}, output]
          rescue Exception => e
            response ||= [400, {'Content-Type' => 'text/plain'}, e.to_s]
          end
        end
      end
      
      response ||= [415, {'Content-Type' => 'text/plain'}, "unsupported media type (gif/png allowed)"]
    when '/'
      response ||= [200, {'Content-Type' => 'text/html'}, %(<html><head><title>Rackviz</title></head><body></body></html>)]
    else
      response ||= [404, {'Content-Type' => 'text/plain'}, "not found"]
  end
  response
end)