class AddStatusToStories < ActiveRecord::Migration[8.0]
  def change
    add_column :stories, :status, :string
  end
end
