require "nokogiri"

f = File.open("shop.xml")
merchandise = Nokogiri::XML(f)
f.close

merchandise.encoding = "utf-8"

categories = merchandise.xpath("//category")
products = merchandise.xpath("//program")

# products.each do |product|
# 	puts product.children
# end

products[0].children.each do |f|
	puts '------------------------'
	puts f.content
end