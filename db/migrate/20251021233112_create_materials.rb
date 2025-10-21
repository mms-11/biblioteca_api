class CreateMaterials < ActiveRecord::Migration[7.1]
  def change
    create_table :materials do |t|
      t.string  :type, null: false           #tipos do material 
      t.string  :title, null: false
      t.text    :description
      t.integer :status, null: false, default: 0 

      t.references :author,  null: false, foreign_key: true
      t.references :creator, null: false, foreign_key: { to_table: :users }

      t.timestamps
    end

    add_index :materials, :type
    add_index :materials, :status
    add_index :materials, :title
  end
end
