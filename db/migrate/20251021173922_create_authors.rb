class CreateAuthors < ActiveRecord::Migration[7.1]
  def change
    create_table :authors do |t|
      t.string :type, null: false            # tipop oessoa | tipo instituicao
      t.string :name, null: false
      t.date   :birthdate                    # apenas tipo pessoa
      t.string :city                         # apenas tipo instituicao
      t.timestamps
    end
    add_index :authors, :type
    add_index :authors, :name
  end
end
