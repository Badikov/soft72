require "./category.rb"

xml_base = File.open("shop.xml").read

categories = Category.parse(xml_base)
programs = Program.parse(xml_base)

#programs.each do |program|
#	puts program.name
#end