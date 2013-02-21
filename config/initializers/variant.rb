Spree::Variant.class_eval do
	def options_text
		values = self.option_values.sort_by(&:position)

		values.map! do |ov|
			" #{ov.presentation}"
		end

		values.to_sentence({ :words_connector => ", ", :two_words_connector => ", " })
	end
end