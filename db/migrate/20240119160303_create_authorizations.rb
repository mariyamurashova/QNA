class CreateAuthorizations < ActiveRecord::Migration[7.1]
  def change
    create_table :authorizations do |t|
      t.references :user, null: false, index: true, foreign_key: true
      t.string :provider
      t.string :uid

      t.timestamps
    end

    add_index :authorizations, [:provider, :uid]
  end
end
