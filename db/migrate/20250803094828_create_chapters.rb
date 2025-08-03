class CreateChapters < ActiveRecord::Migration[8.0]
  def change
    create_table :chapters do |t|
      t.string :text_path
      t.string :image_path
      t.references :story, null: false, foreign_key: true

      t.timestamps
    end
  end
end
