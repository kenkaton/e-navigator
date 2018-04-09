class Interview < ApplicationRecord
  belongs_to :user
  enum approval: { pending: 0, approve: 1, reject: 2 }
  after_update :reject_other_interviews

  private
    def reject_other_interviews
      if self.approval == 'approve'
        Interview.where('user_id = ? AND NOT (id = ?)', self.user_id, self.id).update_all(approval: 'reject')
      end
    end
end
