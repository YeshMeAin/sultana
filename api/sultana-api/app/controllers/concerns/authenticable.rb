module Authenticable
  def authenticate_request!
    return if current_user

    render json: { error: 'Not Authorized' }, status: :unauthorized
  end

  def current_user
    @current_user ||= User.find(decoded_auth_token[:user_id]) if decoded_auth_token
  rescue ActiveRecord::RecordNotFound
    nil
  end

  private

  def decoded_auth_token
    @decoded_auth_token ||= JsonWebToken.decode(http_token)
  end

  def http_token
    if request.headers['Authorization'].present?
      request.headers['Authorization'].split(' ').last
    end
  end
end
