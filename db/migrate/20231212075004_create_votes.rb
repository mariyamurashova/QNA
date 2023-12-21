class CreateVotes < ActiveRecord::Migration[7.1]
  def change
    create_table :votes do |t|
      t.integer :value, default: 0
      t.belongs_to :vottable, polymorphic: true
      t.belongs_to :user, foreign_key: true

      t.timestamps
    end
  end
end
