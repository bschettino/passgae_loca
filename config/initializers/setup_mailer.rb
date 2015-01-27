# -*- encoding : utf-8 -*-
#require 'development_mail_interceptor'

#A linha abaixo registra o interceptor, de tal forma que, se o projeto
#está em development, ao invéz de mandar e-mail para a pessoa, por default ele manda
#e-mail para a conta registrada em development_mail_interceptor
#na linha:    message.to = "cartaouff4all@gmail.com"
class DevelopmentMailInterceptor
  def self.delivering_email(message)
    if Rails.env.production? || Rails.env.test?
      if message.to.blank?
        message.perform_deliveries= false
      end
    else
      message.from = "cartaouff2all@gmail.com"
      message.to = "bpschettino@gmail.com" if Rails.env.development?
      #message.bcc = "hsribas@id.uff.br" if Rails.env == "homologacao"
    end
  end
end
ActionMailer::Base.register_interceptor(DevelopmentMailInterceptor)

#Para enviar e-mail com esses settings, mude :user_name e :password para
#seu nome de usuario e senha no gmail, ou mude port, domain, user_name e
#password para os dados comentados para mandar pelo id.uff.br
#ActionMailer::Base.smtp_settings = {
#  :address              => "mail.uff.br",
#  :port                 => "25",
#  :domain               => "uff.br",
#  :port                 => "25",
#  :domain               => "uff.br",
#  :user_name            => "exemplo@id.uff.br",
#  :password             => "MINHASENHA",
#  :authentication       => "plain",
#  :enable_starttls_auto => true
#}


#Para utilizar o smtp da uff (em uma máquina de homologação com autorização para utilizar o smtp:
#comente as settings acima e utilize as settings abaixo.
#possívelmente precisará de um :user_name ou :password
if Rails.env == 'production'
  ActionMailer::Base.smtp_settings = {
      :address => "mail.uff.br",
      :port => 25,
      :domain => "uff.br" # É necessário especificar um domínio qualquer.
  }
else
  ActionMailer::Base.smtp_settings = {
      :address              => "smtp.gmail.com",
      :port                 => 587,
      :user_name            => 'bschettino@id.uff.br',
      :password             => ENV['senha_email'],
      :authentication       => 'plain',
      :enable_starttls_auto => true
  }
end
