module ChainSelectsHelper
  # creates a chain of drop-down boxes given a set of models
  def chain_select_ajax(options = {})
    html = ""
    
    prefix = (options[:prefix] or 'chain_select').to_s
    spacer = (options[:spacer] or '').to_s
    
    if options[:models]
      for model_name in options[:models]

        # get options for this model
        options = chain_select_model_options(model_name, options)
        
        # don't add the spacer on the last drop-down
        spacer = '' if options[:models].last == model_name
        
        html += (chain_select_for_model(model_name, prefix, options) + spacer)
      end
    end
    
    unless options[:disable_ajax_indicator]
      html += chain_select_indicator('global', prefix)
    end
    
    html
  end
  
  def chain_select_stand_alone(model_name, options = {})
    ar_model = constantize_model(model_name)
    prefix = (options[:prefix] or 'chain_select').to_s

    # adapt the :value to look like it is being called
    # from chain_select_ajax(:values => {:manufacturer => 2, :brand => 4, :make_model => 3})
    if options[:value] and options[:parent]
      options[:values] = {}
      options[:values][model_name] = options[:value]
      options[:values][ar_model.chain_select_from] = options[:parent]
    end

    # get options for this model
    options = chain_select_model_options(model_name, options)
    
    chain_select_for_model(model_name, prefix, options)
  end
  
  # sets up the options for the model
  def chain_select_model_options(model_name, options = {})
    ar_model = constantize_model(model_name)
    
    # always display the data for the 1st drop-down
    if ar_model.is_chain_select_root?
      options[:select_txt_only] = nil
      options[:value] = options[:values][model_name] if options[:values] and options[:values][model_name]
      
    # for succeeding drop-downs, either display a plain "-- Select --"
    # or display a selected value
    else
      # user specified a value so we need to retrieve all data that are related to it
      if options[:values] and options[:values][model_name]
        options[:value] = options[:values][model_name]
        options[:parent] = [options[:values][ar_model.chain_select_from], ar_model.chain_select_from.to_s]
      else
        options[:select_txt_only] = true
      end
    end
    
    options
  end
  
  def chain_select_indicator_stand_alone(prefix)
    chain_select_indicator('global', prefix)
  end
  
  def chain_select_for_model(model_name, prefix = 'chain_select', options = {})
    # make the model callable (summoning ...)
    ar_model = constantize_model(model_name)
    
    # element id of the drop-down
    select_name = chain_select_name(model_name, prefix)
    
    drop_down_options = {}
    drop_down_options[:class_name] = model_name.to_s
    drop_down_options[:select_txt_only] = true if options[:select_txt_only]
    drop_down_options[:disable_select_txt] = true if options[:disable_select_txt]
    drop_down_options[:parent] = options[:parent] if options[:parent]
    
    # get the data for the drop-down
    select_option_data = ar_model.chain_drop_down(drop_down_options)
    
    # generate the options and more importantly, the code for ajax events
    select_options = chain_select_options(model_name, prefix)
    select_options[:value] ||= options[:value]
    
    # model is not a chain for anything, i.e. last drop-down
    unless ar_model.can_chain_child?
      select_options[:onchange] = nil
    end
    
    select_options[:name] = chain_select_form_name(model_name, prefix)
    
    select_options_tag(select_name, select_option_data, select_options)
  end
  
  # generates the spinning ajax indicator
  # this is not configurable at the moment
  # just replace the file ajax-loader in public/images
  # if you want to change it
  def chain_select_indicator(model_name, prefix = 'chain_select')
    image_tag('ajax-loader.gif', :id => chain_select_indicator_name(model_name, prefix), :style => 'display: none;', :class => 'chain_select_indicator')
  end
  
  # creates a vanila drop-down select box
  # name - name of the select box
  # select_options - an array that contains the contents of the drop-down
  #                  select box, each element of the 
  #                  array contains a sub-array in the format of:
  #                  ['Text', id]
  #                  Where 'Text' appears in the drop-down box
  # options - misc html options
  def select_options_tag(name = '', select_options = {}, options= {})
    selected = ''
    
    unless options[:value].blank?
      selected = options[:value]
      options.delete(:value)
    end
    
    select_tag(name, options_for_select(select_options, selected), options)
  end
  
  # generates the element id and name of a drop-down box
  # e.g. <select id="chain_select_manufacturer">
  def chain_select_name(model_name, prefix = 'chain_select')
    "#{prefix}_#{model_name}"
  end
  
  # generates the element name of the drop-down box
  # e.g. <select name="chain_select[manufacturer]">
  def chain_select_form_name(model_name, prefix = 'chain_select')
    "#{prefix}[#{model_name}]"
  end
  
  # element id of the ajax indicator for a set of drop-downs
  def chain_select_indicator_name(model_name, prefix = 'chain_select')
    "indicator_for_#{chain_select_name(model_name, prefix)}"
  end
  
  # generate the Ajax call when the user changes the data in the drop-down
  def chain_select_options(model_name, prefix)
    indicator_id = chain_select_indicator_name('global', prefix)
    
    {:onchange => "new Ajax.Request('/chain_selects/query/' + this.value + '?parent=#{model_name}&prefix=#{prefix}&authenticity_token=#{form_authenticity_token}', {asynchronous:true, evalScripts:true,onLoading:function(request){$('#{indicator_id}').show()},onComplete:function(request){$('#{indicator_id}').hide()}}); return false;", :class => 'chain_select_boxes'}
  end
  # 
  # converts a symbol of string to a constant
  # :manufacturer => Manufacturer
  def constantize_model(model_name)
    eval(model_name.to_s.camelize)
  end
  
  # alias for options_for_select
  def chain_select_options_data(select_options, selected = nil)
    options_for_select(select_options, selected)
  end
end