Deface::Override.new(
	:name => "pimport_tab",
	:virtual_path => "spree/layouts/admin",
	:insert_bottom => "[data-hook='admin_tabs'], #admin_tabs[data-hook]",
	# :text => '<li><a href="/admin/promotions">Import products</a></li>'
	:text => '<%= tab :pimport %>'
)