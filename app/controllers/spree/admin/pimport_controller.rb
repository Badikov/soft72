module Spree
	module Admin
		class PimportController < Spree::Admin::BaseController
			require 'nokogiri'

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
					f = File.open(uploaded_file_path)
					merchandise = Nokogiri::XML(f)
					f.close

					merchandise.encoding = "utf-8"

					categories = merchandise.xpath("//category")
					# products = merchandise.xpath("//program")

          categories.each do |category|
            if category["parentId"] === "0"
              catalog_array = Hash[category["id"]], Array.[](category.content)
            else
              current_category = catalog_array[category["parentId"]]
              current_category = current_category.push(category["id"], category.content)
            end
          end

					#categories.each do |category|
					#	if category['parentId'] == '0'
					#		taxonomy = Taxonomy.find_or_initialize_by_id(category['id'])
					#		taxonomy.id, taxonomy.name = category['id'], category.content
					#		taxonomy.save
					#	else
					#		taxon = Taxon.find_or_initialize_by_id(category['id'])
					#		if parent_id != category['parentId']
					#			parent_id = category['parentId']
					#			taxon_position = 0
					#		end
					#		taxon.parent_id = category['parentId']
					#		taxon_position = taxon_position + 1
					#		taxon.id, taxon.position, taxon.taxonomy_id, taxon.name = category['id'], taxon_position, category['parentId'], category.content
           #   taxon.set_permalink
					#		taxon.save
					#	end
					#end

					# products.each do |product| do
					# 	taxon = Taxon.find_or_initialize_by_id(product['id'])
					# 	taxon.id, taxon.name = product['id'], product.content
					# 	taxon.save
					# end

				end

        @catalog_array = catalog_array

			end

		end
	end
end