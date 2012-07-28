class User < ActiveRecord::Base
  
  has_secure_password
  
  # not allowed are :admin:boolean, :auth_token:string, password_reset_token:string, password_reset_sent_at:datetime
  attr_accessible :email, :password, :password_confirmation, :first_name, :last_name
  
  validates_uniqueness_of :email, :case_sensitive => false
  validates_presence_of :password, on: :create
  validates_presence_of :first_name
  validates_presence_of :last_name
  
  before_create { generate_token(:auth_token) }
  
  # use the stringex gem to create slug | usually on the title or name attribute
  def to_param
    "#{id}-#{name.to_url}"
  end

  scope :by_recent, :order => 'updated_at desc'
  
  def name
    result = "#{first_name} #{last_name}".strip
  end

  def send_password_reset
    generate_token(:password_reset_token)
    self.password_reset_sent_at = Time.zone.now
    save!
    UserMailer.password_reset(self).deliver
  end

  def generate_token(column)
    begin
      self[column] = SecureRandom.urlsafe_base64
    end while User.exists?(column => self[column])
  end
  
end
