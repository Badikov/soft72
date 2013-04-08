require "happymapper"

class Price
	include HappyMapper
	tag 'price'
	attribute :id, String, tag: 'id'
	element :name, String, tag: 'name'
	element :range_name, String, tag: 'range_name'
	element :value, String, tag: 'value'
end

class Version
	include HappyMapper
	tag 'version'
	has_many :prices, Price, tag: 'price'
	attribute :id, Integer, tag: 'id'
	element :name, String, tag: 'name'
	element :fullname, String, tag: 'fullname'
	element :description, String, tag: 'description'
	element :license_type, String, tag: 'license_type'
	element :os, String, tag: 'os'
end

class Program
	include HappyMapper
	tag 'program'
	has_many :versions, Version, tag: 'version'
	attribute :id, Integer, tag: 'id'
	element :category_id, Integer, tag: 'categoryId', xpath: 'categories'
	element :name, String, tag: 'name'
	element :image, String, tag: 'image'
	element :full_desc, String, tag: 'full_desc'
	element :short_desc, String, tag: 'short_desc'
	element :vendor, String, tag: 'vendor'
end

class Category
	include HappyMapper
	tag 'category'
	attribute :id, Integer, tag: 'id'
	attribute :parent_id, Integer, tag: 'parentId'
	content :name, String
end

class Shop
	include HappyMapper
	tag 'shop'
	has_many :programs, Program, tag: 'program'
	has_many :categories, Category, tag: 'category'
end