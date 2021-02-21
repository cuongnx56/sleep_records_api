Rails.application.routes.draw do
  use_doorkeeper do
    skip_controllers :authorizations, :applications, :authorized_applications
  end

  mount API::Base, at: '/'
  mount GrapeSwaggerRails::Engine => '/swagger'
end
