class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable
  enum gender: { male: 0, female: 1 }
  has_many :interviews

  def age
    date_format = "%Y%m%d"
    (Date.today.strftime(date_format).to_i - self.birthday&.strftime(date_format).to_i) / 10000 if self.birthday
  end
end
