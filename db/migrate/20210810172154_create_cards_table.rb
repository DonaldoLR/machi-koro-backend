class CreateCardsTable < ActiveRecord::Migration[5.2]
  def change
    create_table :cards do |t|
      t.string :name
      t.string :design_img
      t.integer :build_cost
      t.belongs_to :establishment, foreign_key: true
    end
  end
end
