Rails.application.routes.draw do
  post 'mails_processor/import'
  post 'mails_processor/exclude'
  get 'mails_processor/download'

  root 'mails_processor#home'

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
