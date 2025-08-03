class AddImageDescriptionToChapter < ActiveRecord::Migration[8.0]
  def change
    add_column :chapters, :image_description, :text, null: false
  end
end
