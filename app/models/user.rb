class User < ActiveRecord::Base
  
  has_secure_password
  
  before_create :generate_auth_token
  
  attr_accessible :assinante, :auth_token, :auth_token_expires_at, :datetime, :email, :password_digest, :username
  
  def auth_token_expired?
    auth_token_expires_at < Time.zone.now
  end
  
  def extend_tokenby(kme=nil)
    new_interval = self.auth_token_expires_at + kme
    self.auth_token_expires_at = new_interval
    save!
  end
  
  def generate_auth_token(expires=nil)
    self.auth_token = SecureRandom.hex(20)
    self.auth_token_expires_at = expires || 20.from_now
  end
  
  def regenerate_auth_token!(expires=nil)
    Rails.logger.info "Regerando user auth_token"
    Rails.logger.info "   Expira em #{expires}" if expires
    new_expires = expires.from_now
    generate_auth_token(new_expires)
    save!
  end
 
  
end
