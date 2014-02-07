class ContactMailer < ActionMailer::Base

  def contact_request(contact_request)
    @subject      =   "Contact request from www.thisissheffield.info"
    @recipients   =   "peoplesguide@scratchmedia.co.uk"
    @from         =   "admin@activenucleus.com"
    @body["contact_request"] = contact_request
  end
  
end
