Rails.application.routes.draw do

  devise_for :users

  # Mails Processor
  post 'mails_processor/import'
  post 'mails_processor/exclude'
  post 'mails_processor/angry'
  post 'mails_processor/download'

  # Search
  post 'search/for_email'

  # DNS
  get  'dns_checker/index'
  post 'dns_checker/check'

  root 'mails_processor#home'

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
