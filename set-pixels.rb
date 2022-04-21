require 'json'
require 'excon'
img = JSON.parse(ARGF.read) #.shuffle
player = ENV['PLAYER'] || "ruby"
# host = "http://localhost:4010"
host = "https://entidplace.fly.dev"
cx = Excon.new(host, persistent: true, debug: false)
img.reject{|x| x['color'] == "rgba(0, 0, 0, 0)" ||  x['color'] == "rgba(255, 255, 255, 1)"}.map{|pixel| {method: 'POST', path: '/api/pixel', persistent: true, :body => pixel.merge(player: player).to_json, :headers => {'Content-Type' => 'application/json'}}}.each_slice(10).to_a.shuffle.each do |reqs|
  print "."
  cx.batch_requests(reqs).map{|x| x.status}
  sleep 1
end
