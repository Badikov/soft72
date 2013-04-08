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

					# Clearing DB
					Taxonomy.delete_all
					Taxon.delete_all
					Product.delete_all
					Variant.delete_all
					OptionType.delete_all
					OptionValue.delete_all

					# Making taxonomy
					taxons = {}
					shop.categories.each do |category|
						if category.parent_id == 0
							taxonomy = Taxonomy.new(
									name: category.name
							)
							taxonomy.id = category.id
							taxonomy.save
						else
							taxons[category.id] = Taxon.new(
									name: category.name,
									parent_id: category.parent_id,
									taxonomy_id: category.parent_id
							)
							taxons[category.id].id = category.id
							taxons[category.id].save
						end
					end

					option_type = OptionType.new(
							name: 'version',
							presentation: t(:version)
					)
					option_type.save

					# Programs
					shop.programs.each do |program|
						if program.versions.count > 1
							program.versions.each do |version|
								p = Product.new(id: version.id)
								p.name = version.fullname
								p.price = version.prices[0].value
								p.available_on = Time.now
								if p.taxons.where(
										name: program.name,
										parent_id: program.category_id,
										taxonomy_id: taxons[program.category_id].parent_id
								).empty?
									p.taxons << Taxon.new(
											name: program.name,
											parent_id: program.category_id,
											taxonomy_id: taxons[program.category_id].parent_id
									)
								end
								p.save
								version.prices.each do |variant|
									v = Variant.new(
											product_id: p.id,
											price: variant.value.to_f
									)
									v.save
									option_value = OptionValue.new(
											name: variant.name.to_url,
											presentation: variant.name
									)
									option_value.option_type = option_type
									option_value.save
									if v.option_values.where(
											name: variant.name.to_url,
											presentation: variant.name
									).empty?
										v.option_values << option_value
									end
								end
							end
						else

						end

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