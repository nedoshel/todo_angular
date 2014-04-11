class Task < ActiveRecord::Base

  validates_presence_of :task_at, :title

  before_create :set_task_at

  private

    def set_task_at
      self.task_at = self.task_at - 4.hour
    end

end
