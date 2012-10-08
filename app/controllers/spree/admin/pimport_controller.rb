module Spree
	module Admin

		require "happymapper"

		#HappyMapper Classes
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

		class PimportController < Spree::Admin::BaseController
			require 'open-uri'

			def index
				
			end

			def upload
				
				# File uploading
        uploaded_io = params[:pimport_file]
				if uploaded_io
					uploaded_file_path = Rails.root.join('public', 'uploads', uploaded_io.original_filename)
					File.open(uploaded_file_path, 'wb') do |uploaded_file|
						uploaded_file.write(uploaded_io.read)
					end

					# Uploaded file parsing
					xml_base = File.open("shop.xml").read

					categories = Category.parse(xml_base)
					programs = Program.parse(xml_base)

					programs.each do |program|
						p = Product.find_or_initialize_by_id(program.id)
						p.name = program.name
						p.price = 100
						p.available_on = Time.now
						p.save

						image_file = open(program.image)

						def
							image_file.original_filename
							base_uri.path.split('/').last
						end

						image = Image.find_or_initialize_by_attachment_file_name(image_file.original_filename)
						image.attachment = image_file
						image.viewable = p
						@image = image
						p.images << image if image.save
					end

				end

			end

		end
	end
end