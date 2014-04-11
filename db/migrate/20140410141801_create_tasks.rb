class CreateTasks < ActiveRecord::Migration
  def change
    create_table :tasks do |t|
      t.string :title
      t.datetime :task_at
      t.boolean :is_complete

      t.timestamps
    end
  end
end
