class Task < ActiveRecord::Base

  validates_presence_of :task_at, :title

  before_create :set_task_at, :set_is_complete

  private
    def set_task_at
      self.task_at = self.task_at - 4.hour
    end

    def set_is_complete
      self.is_complete ||= false
    end
end
