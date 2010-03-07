ActiveRecord::Schema.define(:version => 0) do
  create_table :manufacturers, :force => true do |t|
    t.string :name
    t.timestamps
  end
  
  create_table :brands, :force => true do |t|
    t.string :name
    t.references :manufacturer
    t.timestamps
  end
  
  create_table :make_models, :force => true do |t|
    t.string :name
    t.references :brand
    t.timestamps
  end
end