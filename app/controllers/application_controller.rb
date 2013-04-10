#encoding: utf-8
class ApplicationController < ActionController::Base
  protect_from_forgery 
  
  def require_authentication
    
      auth_token = request.headers["auth_token"]
      
      @user = User.find_by_auth_token(auth_token)
      
      if @user
        if !@user.auth_token_expired?
          # render :text => "Usuário #{@user.username} logado."
          render :json => {
            :username => @user.username,
            :email => @user.email,
            :assinante => @user.assinante,
            'expira_em' => @user.auth_token_expires_at.to_s(:lasting),
          }
        else
          render :status => 401, :text => "Sessão do usuário #{@user.username} expirada."  
        end
      else
        render :status => 401, :text => "Requer credenciais válidas."
      end
    
  end
end
