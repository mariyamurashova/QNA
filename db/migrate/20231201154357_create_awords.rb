class CreateAwords < ActiveRecord::Migration[7.1]
  def change
    create_table :awords do |t|
      t.string :title
      t.string :image
      t.belongs_to :question, null: false, foreign_key: true

      t.timestamps
    end
  end
end
