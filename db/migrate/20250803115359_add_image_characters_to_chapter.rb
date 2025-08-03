class AddImageCharactersToChapter < ActiveRecord::Migration[8.0]
  def change
    add_column :chapters, :image_characters, :string, array: true, default: []
  end
end
