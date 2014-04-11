class ChangeIsCompleteInTasks < ActiveRecord::Migration
  def change
    change_column :tasks, :is_complete, :boolean, default: false
  end
end
