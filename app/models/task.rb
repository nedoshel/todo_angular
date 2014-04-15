class Task < ActiveRecord::Base

  validates_presence_of :task_at, :title

  before_create :set_task_at
  before_update :update_task_at
  private

    def set_task_at
      self.task_at = self.task_at - 4.hour
    end

    def update_task_at
      self.task_at = self.task_at - 4.hour if task_at_changed?
    end



end
