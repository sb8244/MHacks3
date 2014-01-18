class ChangeMailer < ActionMailer::Base
  default from: "watch@content2img.com"

  def notify_user(user, history)
    @user = user
    @history = history
    mail(to: @user.email, subject: "Your watched content changed!")
  end
end
