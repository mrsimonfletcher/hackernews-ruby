class Resolvers::SignInUser < GraphQL::Function
  argument :email, !Types::AuthProviderEmailInput

  # defines inline return type for the mutation
  type do
    name 'SignInPayload'

    field :token, !types.String
    field :user, Types::UserType
  end

  def call(_obj, args, ctx)
    input = args[:email]

    # basic validation
    return unless input

    user = User.find_by(email: input[:email])

    # ensures we have the correct user
    return unless user
    return unless user.authenticate(input[:password])

    crypt = ActiveSupport::MessageEncryptor.new(Rails.application.secrets.secret_key_base.byteslice(0..31))
    token = crypt.encrypt_and_sign("user-id:#{ user.id }")

    ctx[:session][:token] = token

    OpenStruct.new(
      token: token,
      user: user
    )
  end
end
