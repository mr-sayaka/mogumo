class CreatePosts < ActiveRecord::Migration[8.0]
  def change
    create_table :posts do |t|
      t.references :user, null: false, foreign_key: true
      t.string :title
      t.text :introduction
      t.text :ingredients
      t.text :how_to_make
      t.string :target_age
      t.text :allergy

      t.timestamps
    end
  end
end
