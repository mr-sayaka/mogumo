class ChangeGroupsUserToAdmin < ActiveRecord::Migration[8.0]
  def up
    add_reference :groups, :admin, foreign_key: true

    admin_id = Admin.first&.id

    if admin_id
      execute <<~SQL
        UPDATE groups
        SET admin_id = #{admin_id}
        WHERE admin_id IS NULL
      SQL
    end

    change_column_null :groups, :admin_id, false

    remove_foreign_key :groups, :users
    remove_index :groups, :user_id
    remove_column :groups, :user_id
  end

  def down
    add_reference :groups, :user, foreign_key: true

    remove_foreign_key :groups, :admins
    remove_index :groups, :admin_id
    remove_column :groups, :admin_id
  end
end