class AddTestAttributeToItems < ActiveRecord::Migration[6.1]
  def change
    add_column :items, :description, :binary
  end
end
