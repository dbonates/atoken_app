#encoding: utf-8
class ApplicationController < ActionController::Base
  protect_from_forgery 
  
  def require_authentication
    
      auth_token = request.headers["auth_token"]
      
      @user = User.find_by_auth_token(auth_token)
      
      if @user
        if !@user.auth_token_expired?
          # render :text => "Usuário #{@user.username} logado."
          
          respond_to do |format|
            
            format.html # renderiza o index.html.erb
            format.json { render json:  {
                       :username => @user.username,
                       :email => @user.email,
                       :assinante => @user.assinante,
                       # :auth_token => @user.auth_token,
                       'expira_em' => "#{(@user.auth_token_expires_at-Time.zone.now).round} segundos",
                     }
            }
            
          end
          
          
          # render :json => {
          #            :username => @user.username,
          #            :email => @user.email,
          #            :assinante => @user.assinante,
          #            # :auth_token => @user.auth_token,
          #            'expira_em' => "#{(@user.auth_token_expires_at-Time.zone.now).round} segundos",
          #          }  
        else
          render :status => 403, :json => { :error => "Sessão do usuário #{@user.username} expirada."}  
        end
      else
        render :status => 401, :json => { error: "Esse acesso requer credenciais válidas."}
      end
    
  end
end
