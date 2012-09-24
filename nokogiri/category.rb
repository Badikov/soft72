require "happymapper"

class Category
	include HappyMapper

	tag 'category'
	content :name, String
	attribute :id, Integer
	attribute :parentId, Integer
end

class Program
	include HappyMapper

	tag 'program'
	attribute :id, Integer
	element :name, String
	element :image, String
	element :full_desc, String
	element :short_desc, String
	element :vendor, String
end