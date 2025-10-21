class AddSpecificFieldsToMaterials < ActiveRecord::Migration[8.0]
  def change
    add_column :materials, :isbn, :string
    add_column :materials, :doi, :string
    add_column :materials, :page_count, :integer
    add_column :materials, :duration_minutes, :integer
  end
end
