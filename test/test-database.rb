require '../mrblib/database.rb'
#Test
#Load Widget.qml
#Create property instances

pd = PropertyDatabase.new
p1 = Property.new("/foobar",   Proc.new {"hello"})
p2 = Property.new("/barfoo",   Proc.new {pd.load_id("/foobar") + " world"})
p3 = Property.new("/blam",     Proc.new {pd.load_id("/foobar") + " bob"})
p4 = Property.new("/blamblam", Proc.new {23})
p5 = Property.new("/yadayada", Proc.new {pd.load_id("/foobar") + " " + pd.load_id("/blamblam").to_s})

pp p1
pp p2
pp p3
pp p4
pp p5
puts

pd.add_property p1
pd.add_property p2
pd.add_property p3
pd.add_property p4
pd.add_property p5

puts "First load..."
print "Expect: \"hello world\"\nGot:    "
pp pd.load_id("/barfoo")

puts
puts "Second load..."
print "Expect: \"hello 23\"\nGot:    "
pp pd.load_id("/yadayada")

pd.write("/foobar", Proc.new {"goodbye"})

pp p1
pp p2
pp p3
pp p4
pp p5

puts "========P1"
pp pd.load_property p1
puts "========P2"
pp pd.load_property p2
puts "========P3"
pp pd.load_property p3
puts "========P4"
pp pd.load_property p4
puts "========P5"
pp pd.load_property p5
puts "========end"

pp p1
pp p2
pp p3
pp p4
pp p5
