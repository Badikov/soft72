module Spree
	module Admin

		class PimportController < Spree::Admin::BaseController

			def index
				
			end

			def upload
				require 'aws/s3'

				# Uploading to S3
				s3 = AWS::S3.new
				bucket = s3.buckets[ENV['S3_BUCKET_NAME']]
				obj = bucket.objects['soft72/xml/' + params[:pimport_file].original_filename]
				obj.write(file: params[:pimport_file].path, multipart_threshold: params[:pimport_file].size)
			end

		end
	end
end