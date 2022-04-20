require 'json'
require 'excon'
img = JSON.parse(ARGF.read) #.shuffle
cx = Excon.new('http://localhost:4010/', :persistent => true)
img.map{|pixel| {method: 'POST', path: '/api/pixel', persistent: true, :body => pixel.merge(player: "Mujju").to_json, :headers => {'Content-Type' => 'application/json'}}}.each_slice(100).to_a.shuffle.each do |reqs|
  cx.batch_requests(reqs)
end
