class AddInterviewerIdToInterviews < ActiveRecord::Migration[5.1]
  def change
    add_column :interviews, :interviewer_id, :integer
  end
end
