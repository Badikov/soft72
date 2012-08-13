Deface::Override.new(
	:name => "products_import_tab",
	:virtual_path => "spree/layouts/admin",
	:insert_bottom => "[data-hook='admin_tabs'], #admin_tabs[data-hook]",
	:text => 'Import products'
	# :text => '<%= tab :products_import %>'
	)