#encoding: utf-8
class AuthController < ApplicationController
  
  before_filter :check_parameters, :except => [:getall]
  
  def getall
    @users = User.order("created_at ASC") 
    render :json => @users
  end
  
  def register
    @user = User.new
    @user.username = params[:username]
    @user.email = params[:email]
    @user.assinante = params[:assinante]
    @user.password = params[:password]
    
    if @user.save
      render :json => {
        :username => @user.username,
        :auth_token => @user.auth_token,
        :auth_token_expires_at => @user.auth_token_expires_at.to_s(:lasting)
      }
      else
        render :status => 405, :text => "Erro criar usuário."
    end
    
  end
  
  def signin
    
    @user = User.find_by_username(params[:username]).try(:authenticate, params[:password])
    
    if @user
      ttl = params[:ttl] ? params[:ttl].to_i : 20
      kme = params[:kme] ? params[:kme].to_i : false
      
      if @user.auth_token_expired?
        @user.regenerate_auth_token!(ttl)
      else
        @user.extend_tokenby(kme) if kme
      end
      
      render :json => {
        :username => @user.username,
        :auth_token => @user.auth_token,
        :auth_token_expires_at => @user.auth_token_expires_at.to_s(:lasting)
      }
      
    else
      render :status => 402, :text => "Credenciais inválidas para esse usuário."
    end
    
  end            
  
  
  private
  
  def check_parameters
    if params[:username].blank? || params[:password].blank?
      
      render :status => 402, :text => "username e password são requeridos."
      
    end
  end
end
