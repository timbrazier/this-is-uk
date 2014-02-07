# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper

  def nice_date(date)
    date.strftime("%A %d %B %Y")
  end

  def add_business_decider
      if params[:cat_sys_name]
      link_to(image_tag("suggest-new-button.gif",:alt=>"Suggest a Business - FREE!"),:controller=>"guide",:action=>"add_business",:cat_sys_name => params[:cat_sys_name])
      link_to(image_tag("add-your-business-button.gif",:alt=>"Add your Business - FREE!"),:controller=>"guide",:action=>"add_business",:cat_sys_name => params[:cat_sys_name])
      if params[:subcat_sys_name]
        link_to(image_tag("suggest-new-button.gif",:alt=>"Suggest a Business - FREE!"),:controller=>"guide",:action=>"add_business",:cat_sys_name => params[:cat_sys_name])
        link_to(image_tag("add-your-business-button.gif",:alt=>"Add your Business - FREE!"),:controller=>"guide",:action=>"add_business",:cat_sys_name => params[:cat_sys_name],:subcat_sys_name=>params[:subcat_sys_name])
        if params[:subsubcat_sys_name]
          link_to(image_tag("suggest-new-button.gif",:alt=>"Suggest a Business - FREE!"),:controller=>"guide",:action=>"add_business",:cat_sys_name => params[:cat_sys_name])
          link_to(image_tag("add-your-business-button.gif",:alt=>"Add your Business - FREE!"),:controller=>"guide",:action=>"add_business",:cat_sys_name => params[:cat_sys_name],:subcat_sys_name=>params[:subcat_sys_name])
        end
      end
    else
      link_to(image_tag("suggest-new-button.gif",:alt=>"Suggest a Business - FREE!"),:controller=>"guide",:action=>"add_business",:cat_sys_name => params[:cat_sys_name])
      link_to(image_tag("add-your-business-button.gif",:alt=>"Add your Business - FREE!"),:controller=>"guide",:action=>"add_business")
    end
  end
  
  def select_decider(type,selector,item)
    case type
      when "category"
        if request.post?
          if selector.id.to_s == item.category_id.to_s
            "selected"
          end
        else
          if selector.cat_sys_name == params[:cat_sys_name]
            "selected"
          end
        end
      when "subcategory"
        if request.post?
          if selector.id.to_s == item.subcategory_id.to_s
            "selected"
          end
        else
          if selector.subcat_sys_name == params[:subcat_sys_name]
            "selected"
          end
        end
      when "subsubcategory"
        if request.post?
          if selector.id.to_s == item.subsubcategory_id.to_s
            "selected"
          end
        else
          if selector.subsubcat_sys_name == params[:subsubcat_sys_name]
            "selected"
          end
        end
    end
  end

end
