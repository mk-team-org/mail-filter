class SearchController < ApplicationController
  def for_email
    @found_contact = Contact.where(email: params[:contact][:email]).first

    render 'mails_processor/home'
  end
end
