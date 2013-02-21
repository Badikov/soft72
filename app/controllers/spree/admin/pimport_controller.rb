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

					# Making taxonomy
					#
					@taxons = {}
					shop.categories.each do |category|
						if category.parent_id == 0
							Taxonomy.where(
									id: category.id,
									name: category.name
							).first_or_create
						else
							@taxons[category.id] = Taxon.where(
									name: category.name,
									parent_id: category.parent_id,
									taxonomy_id: category.parent_id
							).first_or_initialize
							@taxons[category.id].id = category.id
							@taxons[category.id].save
						end
					end

					option_type = OptionType.where(
							name: 'version',
							presentation: 'Version'
					).first_or_create

					# Programs
					#
					shop.programs.each do |program|
						if program.versions.count > 1
							program.versions.each do |version|
								@p = Product.where(id: version.id).first_or_initialize
								@p.name = version.fullname
								@p.price = version.prices[0].value
								@p.available_on = Time.now
								if @p.taxons.where(
										name: program.name,
										parent_id: program.category_id,
										taxonomy_id: @taxons[program.category_id].parent_id
								).empty?
									@p.taxons << Taxon.where(
											name: program.name,
											parent_id: program.category_id,
											taxonomy_id: @taxons[program.category_id].parent_id
									).first_or_initialize
								end
								@p.save
								version.prices.each do |variant|
									v = Variant.where(
											product_id: @p.id,
											price: variant.value.to_f
									).first_or_create
									option_values = OptionValue.where(
											name: variant.name.to_url,
											presentation: variant.name
									).first_or_create
									option_values.option_type = option_type
									option_values.save
									if v.option_values.where(
											name: variant.name.to_url,
											presentation: variant.name
									).empty?
										v.option_values << option_values
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