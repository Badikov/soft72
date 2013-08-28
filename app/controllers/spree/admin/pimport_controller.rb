module Spree
	module Admin

		class PimportController < Spree::Admin::BaseController

			def index
				#require 'aws/s3'
				# Uploading to S3
				if params[:catalog_file]
					#s3 = AWS::S3.new
					#bucket = s3.buckets[ENV['S3_BUCKET_NAME']]
					#obj = bucket.objects['soft72/xml/' + params[:pimport_file].original_filename]
					#obj.write(file: params[:pimport_file].path)

					# Thru S3
					Pimport.new(params[:catalog_file])
				else
				end
			end

		end
	end
end