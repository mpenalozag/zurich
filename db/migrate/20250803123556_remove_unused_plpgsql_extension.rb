class RemoveUnusedPlpgsqlExtension < ActiveRecord::Migration[8.0]
  def up
    disable_extension "plpgsql"
  end

  def down
    enable_extension "plpgsql"
  end
end
