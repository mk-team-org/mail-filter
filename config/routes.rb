Rails.application.routes.draw do

  post 'mails_processor/import'
  post 'mails_processor/exclude'
  post 'mails_processor/angry'
  post 'mails_processor/download'
  post 'search/for_email'

  root 'mails_processor#home'

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
