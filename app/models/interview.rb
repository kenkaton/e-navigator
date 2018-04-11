class Interview < ApplicationRecord
  validate :date_cannot_be_in_the_past
  validate :cannot_edit_schedule_that_was_approved_or_rejected
  belongs_to :user
  enum approval: { pending: 0, approve: 1, reject: 2 }
  before_destroy :cannot_edit_schedule_that_was_approved_or_rejected
  after_update :reject_other_interviews

  def date_cannot_be_in_the_past
    if self.date.present? && self.date < Date.today
      errors.add(:date, "can't be in the past")
    end
  end

  def cannot_edit_schedule_that_was_approved_or_rejected
    if Interview.find_by(id: self.id)&.approval.in?(['approve','reject'])
      errors[:base] << "The schedule can't be edited because it has already been approved or rejected"
      throw :abort
    end
  end

  private
    def reject_other_interviews
      if self.approval == 'approve'
        Interview.where('user_id = ? AND NOT (id = ?)', self.user_id, self.id).update_all(approval: 'reject')
      end
    end
end
