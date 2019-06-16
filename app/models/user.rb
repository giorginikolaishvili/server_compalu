class User < ApplicationRecord
  belongs_to :profile
  before_save {self.email.downcase!}
  before_create :set_timestamps_create
  before_save :set_timestamps, :set_full_name

  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i

  validates :email, presence: true,
            uniqueness: {case_sensitive: false},
            format: {with: VALID_EMAIL_REGEX}
  validates :password,
            length: {minimum: 6},
            if: -> {new_record? || !password.nil?}

  has_secure_password

  def set_timestamps
    self.updated_at = DateTime.now
  end

  def set_timestamps_create
    self.created_at = DateTime.now
    self.updated_at = DateTime.now
  end

  def set_full_name
    self.full_name = "#{self.name} #{self.last_name}"
  end
end
