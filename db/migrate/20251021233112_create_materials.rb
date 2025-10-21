class AddSpecificFieldsToMaterials < ActiveRecord::Migration[7.1]
  def change
    add_column :materials, :isbn,             :string   # variavel para identificar materiais do tipo Book
    add_column :materials, :page_count,       :integer  # armazena quantidade de paginas de Book
    add_column :materials, :doi,              :string   # identificador do artigo 
    add_column :materials, :duration_minutes, :integer  # duração do Video

    # Unicidade por tipo de identificador
    add_index :materials, :isbn, unique: true, where: "isbn IS NOT NULL"
    add_index :materials, :doi,  unique: true, where: "doi IS NOT NULL"
  end
end
