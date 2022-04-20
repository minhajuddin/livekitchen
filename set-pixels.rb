require 'json'
require 'excon'
img = JSON.parse(ARGF.read) #.shuffle
player = ENV['PLAYER'] || "ruby"
host = 'http://localhost:4010/'
# host = "https://entidplace.fly.dev"
cx = Excon.new(host, :persistent => true)
img.map{|pixel| {method: 'POST', path: '/api/pixel', persistent: true, :body => pixel.merge(player: player).to_json, :headers => {'Content-Type' => 'application/json'}}}.each_slice(10).to_a.shuffle.each do |reqs|
  puts cx.batch_requests(reqs).map{|x| x.status}
  sleep 1
  puts "----------------------------------------"
end
