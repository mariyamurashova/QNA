class AddUserToQuestions < ActiveRecord::Migration[7.1]
  def change
    add_reference :questions, :user, null: false, foreign_key: true
    rename_column :questions, :user_id, :author_id
  end
end
