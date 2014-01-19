class ChangeMailer < ActionMailer::Base
  default from: "watch@content2img.com"

  def notify_user(user, history, previous)
    @user = user
    @new = history
    @previous = previous
    mail(to: @user.email, subject: "Your watched content changed!")
  end
end
