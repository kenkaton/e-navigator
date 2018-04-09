class Interview < ApplicationRecord
  validate :date_cannot_be_in_the_past
  belongs_to :user
  enum approval: { pending: 0, approve: 1, reject: 2 }
  after_update :reject_other_interviews

  def date_cannot_be_in_the_past
    if self.date.present? && self.date < Date.today
      errors.add(:date, "can't be in the past")
    end
  end
  
  private
    def reject_other_interviews
      if self.approval == 'approve'
        Interview.where('user_id = ? AND NOT (id = ?)', self.user_id, self.id).update_all(approval: 'reject')
      end
    end
end
