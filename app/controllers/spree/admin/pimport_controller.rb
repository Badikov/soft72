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
							taxonomy = Taxonomy.create(
									name: category.name
							)
							taxons[category.id] = taxonomy.root
						else
							taxons[category.id] = Taxon.create(
									name: category.name,
									parent_id: taxons[category.parent_id].id,
									taxonomy_id: taxons[category.parent_id].id
							)
						end
					end

					option_type = OptionType.new(
							name: 'version',
							presentation: t(:version)
					)
					option_type.save

					# Programs
					shop.programs.each do |program|

						# Make Taxon if more than 1 Variants
						if program.versions.size > 1
							program_taxons = Taxon.create(
									name: program.name,
									parent_id: taxons[program.category_id].id,
									taxonomy_id: taxons[program.category_id].id
							)
						end

						program.versions.each do |version|
							p = Product.create(
								name: version.fullname,
								price: version.prices[0].value.to_f,
								available_on: Time.now
							)
							if p.taxons.where(
									name: program.name,
									parent_id: taxons[program.category_id].id,
									taxonomy_id: taxons[program.category_id].id
							).empty?
								p.taxons << Taxon.new(
										name: program.name,
										parent_id: taxons[program.category_id].id,
										taxonomy_id: taxons[program.category_id].id
								)
							end
							version.prices.each do |variant|
								v = Variant.create(
										product_id: p.id,
										price: variant.value.to_f
								)
								unless variant.name.nil?
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
end