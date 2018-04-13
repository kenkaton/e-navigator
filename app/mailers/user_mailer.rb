class UserMailer < ApplicationMailer

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.user_mailer.apply.subject
  #
  def apply(user)
    @user = user
    mail  to: user.email, subject: 'Notification of desired interview date' do |format|
      format.text { render layout: 'mailer' }
    end
  end

  def notify_interviewer(interview, interviewer, interviewee)
    @interview, @interviewer, @interviewee = interview, interviewer, interviewee
    mail  to: interviewer.email, subject: 'Notification of interview schedule',template_name: 'notify_interviewer' do |format|
      format.text { render layout: 'mailer' }
    end
  end

  def notify_interviewee(interview, interviewer, interviewee)
    @interview, @interviewer, @interviewee = interview, interviewer, interviewee
    mail  to: interviewee.email, subject: 'Notification of interview schedule',template_name: 'notify_interviewee' do |format|
      format.text { render layout: 'mailer' }
    end
  end
end
