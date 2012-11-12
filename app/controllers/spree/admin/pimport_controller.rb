module Spree
	module Admin

		class PimportController < Spree::Admin::BaseController

			def index
				
			end

			def upload
				require 'open-uri'
				require "pimport/allsoft"
				
				# File uploading
        uploaded_io = params[:pimport_file]
				if uploaded_io
					uploaded_file_path = Rails.root.join('public', 'uploads', uploaded_io.original_filename)
					File.open(uploaded_file_path, 'wb') do |uploaded_file|
						uploaded_file.write(uploaded_io.read)
					end

					# Uploaded file parsing
					xml_base = File.open(uploaded_file_path).read
					shop = Shop.parse(xml_base, single: true)

					# Taxons
					# If parent_id == 0 then it's a main category (Taxonomy) of product
					@taxons = {}
					shop.categories.each do |category|
						if category.parent_id == 0
							Taxonomy.find_or_create_by_id_and_name(category.id, category.name)
						end
						@taxons[category.id] = category
					end

					# Programs
					#
					shop.programs.each do |program|
						p = Product.find_or_initialize_by_id(program.id)
						p.name = program.name
						p.price = 100
						p.available_on = Time.now

						def taxon_parent(taxon)
							t = Taxonomy.find_by_id(taxon)
							if t
								Taxon.find_by_name(t.name).id
							end
						end

						p.taxons << Taxon.find_or_create_by_id_and_name_and_parent_id_and_taxonomy_id(
								@taxons[program.category_id].id,
								@taxons[program.category_id].name,
								taxon_parent(@taxons[program.category_id].parent_id),
								@taxons[program.category_id].parent_id)

						p.save

						#image_file = open(program.image)
						#def
						#image_file.original_filename
						#	base_uri.path.split('/').last
						#end
						#image = Image.find_or_initialize_by_attachment_file_name(image_file.original_filename)
						#image.attachment = image_file
						#image.viewable = p
						#@image = image
						#p.images << image if image.save
					end

				end

			end

		end
	end
end