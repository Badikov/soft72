module Spree
	class Pimport
		include AbstractController::Translation


		def initialize(catalog_xml)
			Taxonomy.delete_all
			Taxon.delete_all
			Product.delete_all
			Variant.delete_all
			OptionType.delete_all
			OptionValue.delete_all
			Asset.delete_all
			ActiveRecord::Base.connection.execute('DELETE FROM "spree_option_values_variants"')
			parse_db(catalog_xml)
		end

		def parse_db(catalog_xml)
			require "pimport/allsoft"
			shop = Shop.parse(catalog_xml.read, single: true)
			# Making taxonomy tree
			taxons = {}
			shop.categories.each do |category|
				if category.parent_id == 0
					category.parent_id = nil
					taxonomy = Taxonomy.create(
							name: category.name
					)
					taxons[category.id] = taxonomy.root
				else
					taxons[category.id] = Taxon.create(
							name: category.name,
							parent_id: taxons[category.parent_id].id,
							taxonomy_id: taxons[category.parent_id].parent_id
					)
				end
			end
			# Making option type
			option_type = OptionType.new(
					name: 'version',
					presentation: t(:version)
			)
			option_type.save
			# Parsing programs
			shop.programs.each do |program|
				# Make program taxon
				program_taxon = Taxon.create(
						name: program.name,
						parent_id: taxons[program.category_id].id,
						taxonomy_id: taxons[program.category_id].parent_id
				)
				# Parsing versions
				program.versions.each do |version|
					p = Product.create(
							name: version.fullname,
							price: version.prices[0].value.to_f,
							available_on: Time.now
					)
					if program.image
						ImageFromUrl.create(
								attachment_file_name: program.image,
								viewable: p.master
						)
					end
					p.taxons << program_taxon
					# Parsing prices
					version.prices.each do |variant|
						v = Variant.create(
								product_id: p.id,
								price: variant.value.to_f
						)
						if version.image
							ImageFromUrl.create(
									attachment_file_name: version.image,
									viewable: v
							)
						end
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
					# Parsing images
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