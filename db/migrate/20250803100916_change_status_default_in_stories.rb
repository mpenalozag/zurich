class ChangeStatusDefaultInStories < ActiveRecord::Migration[8.0]
  def change
    change_column_default :stories, :status, "creating"
  end
end
