class AddVisibilityAndGroupToPosts < ActiveRecord::Migration[8.0]
  def change
    add_column :posts, :visibility, :string, null: false, default: "public"
    add_reference :posts, :group, foreign_key: true
  end
end