class AddBugsToAssignments < ActiveRecord::Migration
  def change
    add_column :assignments, :bugs, :string
  end

  def self.down
    remove_column :assignments, :bugs
  end
end
