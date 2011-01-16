every 1.day, :at => '9:00am' do
  command "#{File.expand_path(File.dirname(__FILE__))}/bin/tweetex"
end

every 1.day, :at => '2:00pm' do
  command "#{File.expand_path(File.dirname(__FILE__))}/bin/tweetex"
end
