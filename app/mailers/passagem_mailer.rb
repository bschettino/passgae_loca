# -*- encoding : utf-8 -*-
class PassagemMailer < ActionMailer::Base
  default :content_type => "text/html"

  def envia_passagem(texto)
    @texto = texto
    mail(:to => 'bpschettino@gmail.com', :subject => "PASSAGEM BARATA").deliver
  end

end
