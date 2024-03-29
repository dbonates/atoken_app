# Sistema de autenticação via token/timeout

A autenticação considera usuários previamente cadastrados no banco de dados. 

Para fins de testes, segue alguns comandos para popular o banco via rails console:


> u = User.create(:username => 'admin', :email => 'admin@dbo.com', :assinante => true) <br />
> password = 'secret' <br />
> u.save

> u = User.create(:username => 'admin2', :email => 'admin2@dbo.com', :assinante => false)<br />
> u.password = 'secret'<br />
> u.save

> u = User.create(:username => 'admin3', :email => 'admin3@dbo.com', :assinante => true)<br />
> u.password = 'secret'<br />
> u.save

Testes realizados usando o app Paw HTTP Client para Mac, mas um bom e conveniente debugger de RESTful service é o RESTClient, para firefox.

- Paw HTT Client => http://luckymarmot.com/
- RESTClient => http://restclient.net/
	
<hr />
### Alguns comandos de exemplo:

##### para criar usuarios:
  > http://localhost:3000/auth/register?username=teste1&email=teste1%40dbo.com&assinante=true&password=secret

##### para listar todos os usuarios cadastrados:
  > http://localhost:3000/auth/getall

##### para logar:
  > http://localhost:3000/auth/signin

###### ... no body:
  > username=admin2&password=secret

###### ... ou  direto:
  > http://localhost:3000/auth/signin?username=admin2&password=secret 
	
	
### parametros opcionais para login/autenticação:
> ttl = tempo em segundos para expirar o token gerado

> kme = tempo em segundos para extender a data de expiração do token (só é processado se o token ainda estiver valendo, ou seja, se o usuário ainda estiver logado)


### Exemplos:

#### Para logar um usuario com prazo de 60 segundos para expirar o login (passando o username e password no body):

  > http://localhost:3000/auth/signin?ttl=60
	
#### para extender em mais 2 minutos a expiração atual do login

  > http://localhost:3000/auth/signin?kme=120



