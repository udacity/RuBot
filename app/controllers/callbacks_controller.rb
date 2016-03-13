class CallbacksController < Devise::OmniauthCallbacksController
    def google_oauth2
        @admin = Admin.from_omniauth(request.env["omniauth.auth"])
        sign_in_and_redirect @admin
    end
end