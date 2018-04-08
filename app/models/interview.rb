class Interview < ApplicationRecord
  belongs_to :user
  enum approval: { pending: 0, approve: 1, reject: 2 }
end
