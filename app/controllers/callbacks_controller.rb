class CallbacksController < Devise::OmniauthCallbacksController
  def google_oauth2
    @admin = Admin.from_omniauth(request.env["omniauth.auth"])
    if @admin.email != ""
      sign_in_and_redirect @admin
    else
      puts "Auth ERROR!!!"
      redirect_to new_admin_session_path, flash: {error: 'You must log in with your Udacity or Knowlabs email address.' } 
    end
  end
end