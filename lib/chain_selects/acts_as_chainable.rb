module ChainSelects
  def self.included(base)
    base.send :extend, ClassMethods
  end

  module ClassMethods
    # This method provides a way for models to be chained using drop-down boxes.
    # All models that will be used on a chain should call acts_as_chainable.
    # Example:
    #
    # Assuming that you are writing a car app store and you have the following relations:
    #
    # Manufacturer -> Brand -> Model
    #
    # Example:
    #
    # Toyota -> Corolla -> Altis
    #
    # class Manufacturer < ActiveRecord::Base
    #  has_many :brands
    #  acts_as_chainable :to => :brand, :root => true
    # end
    #
    # class Brand < ActiveRecord::Base
    #  belongs_to :manufacturer
    #  has_many :make_models
    #  acts_as_chainable :to => :make_model, :from => :manufacturer
    # end
    #
    def acts_as_chainable(options = {})
      cattr_accessor :chain_select_child
      cattr_accessor :chain_select_label
      cattr_accessor :chain_select_root
      cattr_accessor :chain_select_from
      
      cattr_accessor :chain_select_order
      cattr_accessor :chain_select_limit
      cattr_accessor :chain_select_conditions
      
      self.chain_select_child = (options[:to] or '').to_s
      self.chain_select_from = (options[:from] or nil)
      self.chain_select_label = (options[:select_label] or '').to_s
      self.chain_select_root = (options[:root] or false)
      
      self.chain_select_order = (options[:order] or nil)
      self.chain_select_limit = (options[:limit] or nil)
      self.chain_select_conditions = (options[:conditions] or nil)
      
      send :include, InstanceMethods
    end
    
    def chain_drop_down(options = {})
      # items[] holds the data for the drop-down
      items = []
      
      return items unless options[:class_name]
      
      # converts :manufacturer to "Manufacturer"
      model_name = options[:class_name].camelize
      
      # constantize the model so we can access it
      ar_model = eval(model_name)

      model_name_label = (self.chain_select_label == '') ? model_name : self.chain_select_label
      
      # set default values for the drop-down
      select_txt = "-- #{model_name_label} --"
      
      # order by primary_key if the order isn't specified
      order = self.chain_select_order
      order = ar_model.send(:primary_key).to_s unless self.chain_select_order
      
      # user can disable the -- Select -- text that is displayed
      # at the first row of the drop-down
      unless options[:disable_select_txt]
        items << [select_txt, '']
        return items if options[:select_txt_only]
      end

      # fills the items array with the children of the parent
      if options[:class_name]
        find_options = {}
        find_options[:conditions] = self.chain_select_conditions if self.chain_select_conditions
        find_options[:order] = self.chain_select_order.to_s if self.chain_select_order
        find_options[:limit] = self.chain_select_limit.to_s if self.chain_select_limit
        
        # call Model.find(:all) based on data provided
        data_items = []
        
        if options[:parent] and options[:parent].class.name == "Array" and options[:parent].length == 2
          # get the parent name, e.g. Manufacturer
          parent_name = options[:parent][1].camelize
          
          # id of the parent
          parent_id = options[:parent][0].to_i

          # the idea here is to do a call like this:
          # Manufacturer.find(1).brands.find(:all, :order => 'name ASC')
          
          # but first, check if the parent is existing
          begin
            eval("#{parent_name}.find(#{parent_id})")
          rescue
            return items
          end
          
          data_items = eval("#{parent_name}.find(#{parent_id}).#{model_name.tableize}").send(:find, :all, find_options)
          
        else
          data_items = ar_model.send(:find, :all, find_options)
        end
        
        for item in data_items 
          items << [item.name, item.id]
        end
      end

      items
    end
    
    # checks if the model is chained to another model,
    # useful in checking if the model is in the bottom
    # of the hierarchy
    def can_chain_child?
      self.chain_select_child.to_s != ''
    end    

    # returns the model's child
    def chain_select_child
      self.chain_select_child
    end
    
    # checks if the model is in the top of the hierarchy
    def is_chain_select_root?
      self.chain_select_root
    end
  end

  module InstanceMethods
    def chain_select_child
      self.class.chain_select_child
    end
  end
end

ActiveRecord::Base.send :include, ChainSelects