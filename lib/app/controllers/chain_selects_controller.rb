class ChainSelectsController < ApplicationController
  # Returns the children of a model as a set of <option> tags.
  # This method is basically used by the ajax calls when the user
  # invokes the onchange event of a particular drop-down box.
  def query
    # let's determine the name of the parent model
    parent_model_name = params[:parent]
    parent_model_id = params[:id]
    @parent_model = constantize_model(parent_model_name)
    
    @prefix = params[:prefix]
    
    child_model_name = @parent_model.chain_select_child
    @child_model = constantize_model(child_model_name)
    
    # find all the children of the parent
    options = {}
    options[:class_name] = child_model_name

    if parent_model_id
      options[:parent] = [parent_model_id, parent_model_name] 
    else
      options[:select_txt_only] = true
    end
    
    @child_select_data = @child_model.chain_drop_down(options)

    @parent_div_id = chain_select_name(parent_model_name, @prefix)
    @child_div_id = chain_select_name(child_model_name, @prefix)
    
    render :update do |page|
      # sets a model's child and child's child, etc to only display the select txt "-- Select --"
      def hide_child_elements(page, model_name)
        ar_model = constantize_model(model_name)

        # base case
        # - this means that we are on the last drop-down in the hierarchy
        if ar_model == nil
          return
        end

        # check if the model has children
        if ar_model.can_chain_child?
          hide_child_elements(page, ar_model.chain_select_child)
        end

        div_id = chain_select_name(model_name, @prefix)

        # get the data of the child for the model
        select_options = chain_select_options_data(ar_model.chain_drop_down(:class_name => model_name.to_s, :select_txt_only => true))

        # update the drop-down to only display the select_txt, e.g. "-- Select --"
        page[div_id].update(select_options)
      end
      
      hide_child_elements(page, @child_model.chain_select_child)
      page[@child_div_id].update(chain_select_options_data(@child_select_data))
      page[chain_select_indicator_name('global', @prefix)].hide
    end
  end
end
