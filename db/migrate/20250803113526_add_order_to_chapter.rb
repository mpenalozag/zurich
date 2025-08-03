class AddOrderToChapter < ActiveRecord::Migration[8.0]
  def change
    add_column :chapters, :order, :integer, null: false
  end
end
