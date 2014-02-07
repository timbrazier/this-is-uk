ActionController::Routing::Routes.draw do |map|
  # The priority is based upon order of creation: first created -> highest priority.
  
  # Sample of regular route:
  # map.connect 'products/:id', :controller => 'catalog', :action => 'view'
  # Keep in mind you can assign values other than :controller and :action

  # Sample of named route:
  # map.purchase 'products/:id/purchase', :controller => 'catalog', :action => 'purchase'
  # This route can be invoked with purchase_url(:id => product.id)

  # You can have the root of your site routed by hooking up '' 
  # -- just remember to delete public/index.html.
  map.connect '', :controller => "guide", :action=>"index"

  # Allow downloading Web Service WSDL as a file with an extension
  # instead of a file named 'wsdl'
  map.connect ':controller/service.wsdl', :action => 'wsdl'

  # Install the default route as the lowest priority.
  map.connect ':controller/:action/:id'
  map.connect 'add-your-business', :controller=>'guide',:action=>'add_business'
  map.connect 'add-your-business/:cat_sys_name', :controller=>'guide',:action=>'add_business'
  map.connect 'add-your-business/:cat_sys_name/:subcat_sys_name', :controller=>'guide',:action=>'add_business'
    map.connect 'add-your-business/:cat_sys_name/:subcat_sys_name/:subsubcat_sys_name', :controller=>'guide',:action=>'add_business'
  map.connect ':cat_sys_name/:subcat_sys_name/:subsubcat_sys_name', :controller => 'guide', :action => 'categories'
  map.connect ':cat_sys_name/:subcat_sys_name/:subsubcat_sys_name/:id', :controller => 'guide', :action => 'detail'
  map.connect ':cat_sys_name/:subcat_sys_name/:subsubcat_sys_name/:id/add_review', :controller => 'guide', :action => 'add_review'
  map.connect ':cat_sys_name/add_item', :controller => 'guide', :action => 'add_item'
  map.connect 'fix_all_missing_subcats', :controller => "guide", :action => 'fix_all_missing_subcats'
end
