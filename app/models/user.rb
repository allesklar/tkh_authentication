class User < ActiveRecord::Base

  has_secure_password

  # associations connected to tkh_content gem. Any page or comment model will do
  has_many :pages
  has_many :comments, :dependent => :destroy, foreign_key: 'author_id'

  # not allowed are :admin:boolean, :auth_token:string, password_reset_token:string, password_reset_sent_at:datetime
  # attr_accessible :email, :password, :password_confirmation, :first_name, :last_name, :other_name

  validates_presence_of :email
  validates_uniqueness_of :email, :case_sensitive => false
  # validates_presence_of :password, on: :create

  # TODO - this needs to be somehow integrated in the click flow
  # validates_presence_of :first_name
  # validates_presence_of :last_name

  scope :alphabetically, -> { order('last_name, first_name') }
  scope :administrators, -> { where('admin = ?', true) }
  scope :by_recent, -> { order('updated_at desc') }

  before_create { generate_token(:auth_token) }

  # use the stringex gem to create slug | usually on the title or name attribute
  def to_param
    "#{id}-#{name.to_url}"
  end


  def name
    "#{first_name} #{last_name}".strip
  end

  def formal_name
    "#{last_name}, #{first_name}".strip
  end

  def spiritual_name
    @spiritual_name = other_name || first_name
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
