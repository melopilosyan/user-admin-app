class User < ActiveRecord::Base

  validates :email, format: { with: /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/i }, uniqueness: true
  validates :password, confirmation: true, length: { minimum: 5 }, if: :password_required?
  validates :full_name, length: { minimum: 5 }
  validates :bio, length: { minimum: 10, maximum: 500 }

  has_attached_file :logo,
                    styles: { thumb: '100x100#', small: '200x200#' },
                    convert_options: { :all => '-strip -quality 70 -interlace Plane' },
                    default_url: '/assets/no-avatar.png'
  validates_attachment_content_type :logo, content_type: /\Aimage\/.*\Z/

  before_create do
    self.salt = Time.now.to_i.to_s
    self.password = encrypt password, self.salt
  end
  before_update do
    self.password = password.strip.empty? ? password_was : encrypt(password, salt)
  end

  module Type
    ADMIN   = 1
    REGULAR = 2
  end

  scope :regulars, -> { where(role: Type::REGULAR).order(id: :desc)}

  def admin?
    self.role == Type::ADMIN
  end

  def check_password(pass)
    self.password == encrypt(pass, self.salt)
  end

 private
  def encrypt(pass, salt)
    Digest::MD5.hexdigest("_#{salt}-|-#{pass.strip}_")
  end

  def password_required?
    self.password.nil?
  end
end
