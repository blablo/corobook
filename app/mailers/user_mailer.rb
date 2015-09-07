# -*- coding: utf-8 -*-
class UserMailer < ActionMailer::Base
  default from: "no-reply@corobook.com"

  def invited_collaborator(creador, user)
    @user = user
    @creador = creador
    mail(:to => "#{user.name} <#{user.email}>", :subject => "#{creador.name} te creó una cuenta en Corobook")
  end
 
  def send_songbook(songbook,user)
    @user = user
    @songbook = songbook
    
    mail(:to => "#{user.name} <blablo@gmail.com>", :subject => "Coros para el" + songbook.fecha.strftime('%e/%m/%Y'))

  end

end
