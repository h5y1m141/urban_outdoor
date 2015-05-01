Rails.application.config.sorcery.submodules = [:remember_me, :reset_password]
Rails.application.config.sorcery.configure do |config|
  # --- user config ---
  config.user_config do |user|
    # -- core --
    # specify username attributes, for example: [:username, :email].
    # Default: `[:email]`
    #
    user.username_attribute_names = [:email]

    # mailer class. Needed.
    # Default: `nil`
    #
    user.reset_password_mailer = UserMailer
  end
  config.user_class = "User"
end
