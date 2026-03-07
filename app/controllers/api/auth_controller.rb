class Api::AuthController < ::ApplicationController
  before_action :authenticate_user!, only: [:logout]

  def login
    user = User.find_by(email: params[:email])

    if user&.valid_password?(login_params[:password])
      token, _payload = Warden::JWTAuth::UserEncoder.new.call(user, :user, nil)

      render json: {
        token: token,
        user: {
          id: user.id,
          email: user.email
        }
      }, status: :ok
    else
      render json: { error: 'Invalid email or password' }, status: :unauthorized
    end
  end

  def logout
    jwt_payload = Warden::JWTAuth::TokenDecoder.new.call(
      request.headers['Authorization'].split(' ').last
    )

    JwtDenylist.create!(
      jti: jwt_payload['jti'],
      exp: Time.at(jwt_payload['exp'])
    )

    render json: { message: 'Logged out successfully' }
  end

  private

  def login_params
    params.permit(:email, :password)
  end
end
