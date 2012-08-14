require "nokogiri"

f = File.open("shop.xml")
merchandise = Nokogiri::XML(f)
f.close

merchandise.encoding = "utf-8"

categories = merchandise.xpath("//category")
products = merchandise.xpath("//program")

categories.each do |category|
	puts category.content()
end