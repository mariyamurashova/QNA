class AddUserToAnswers < ActiveRecord::Migration[7.1]
  def change
    add_reference :answers, :user, null: false, foreign_key: true
    rename_column :answers, :user_id, :author_id
  end
end
