class CreateEstablishmentsTable < ActiveRecord::Migration[5.2]
  def change
    create_table :establishments do |t|
      t.string :color
      t.string :name
      t.string :description
      t.integer :priority_order
    end
  end
end
