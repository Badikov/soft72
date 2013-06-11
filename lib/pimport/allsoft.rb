require "happymapper"

class Price
	include HappyMapper
	tag 'price'

	attribute :id, String, tag: 'id'
	has_one :name, String, tag: 'name'
	has_one :range_name, String, tag: 'range_name'
	has_one :value, String, tag: 'value'
end

class Version
	include HappyMapper
	tag 'version'

	has_many :prices, Price, tag: 'price'
	attribute :id, Integer, tag: 'id'
	has_one :name, String, tag: 'name'
	has_one :fullname, String, tag: 'fullname'
	has_one :description, String, tag: 'description'
	has_one :license_type, String, tag: 'license_type'
	has_one :os, String, tag: 'os'
end

class Program
	include HappyMapper
	tag 'program'

	has_many :versions, Version, tag: 'version'
	attribute :id, Integer, tag: 'id'
	has_one :category_id, Integer, tag: 'categoryId', xpath: 'categories'
	has_one :name, String, tag: 'name'
	has_one :image, String, tag: 'image'
	has_one :full_desc, String, tag: 'full_desc'
	has_one :short_desc, String, tag: 'short_desc'
	has_one :vendor, String, tag: 'vendor'
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

	has_many :programs, Program, tag: 'program', xpath: '/yml_catalog/shop'
	has_many :categories, Category, tag: 'category', xpath: '/yml_catalog/shop/categories'
end