class Interview < ApplicationRecord
  validate :date_cannot_be_in_the_past
  validate :cannot_edit_schedule_that_was_approved_or_rejected
  belongs_to :user
  enum approval: { pending: 0, approve: 1, reject: 2 }
  before_destroy :cannot_destroy_schedule_that_was_approved_or_rejected
  after_update :reject_other_interviews, :notify_the_interview

  def date_cannot_be_in_the_past
    if self.date.present? && self.date < Date.today
      errors.add(:date, "can't be in the past")
    end
  end

  def cannot_destroy_schedule_that_was_approved_or_rejected
    if self.approval.in?(['approve','reject'])
      errors[:base] << "The schedule can't be destroy because it has already been approved or rejected"
      throw :abort
    end
  end

  def cannot_edit_schedule_that_was_approved_or_rejected
    if self.approval.in?(['approve','reject']) && self.date_changed?
      errors[:base] << "The schedule can't be edited because it has already been approved or rejected"
      throw :abort
    end
  end

  def notify_the_interview
    if self.approval == 'approve' && self.approval_changed?
      UserMailer.notify(self, User.find(self.interviewer_id), User.find(self.user_id)).deliver
    end
  end

  private
    def reject_other_interviews
      if self.approval == 'approve'
        Interview.where('user_id = ? AND NOT (id = ?)', self.user_id, self.id).update_all(approval: 'reject')
      end
    end
end
