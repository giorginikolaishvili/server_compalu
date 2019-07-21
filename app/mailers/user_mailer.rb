class UserMailer < ActionMailer::Base
  def send_user_info(params)
    user_mails = params[:ids].present? ? User.where(id: params[:ids]).pluck(:email) : User.all.pluck(:email)

    user_mails.each do |e_mail|
      ActionMailer::Base.mail(from: 'cybercompalu@gmail.com',to: e_mail,
                              subject: params[:subject], body: params[:body]).deliver_now
    end

    {success: true }
  end
end

