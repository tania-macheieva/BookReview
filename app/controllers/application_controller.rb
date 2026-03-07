class ApplicationController < ActionController::API
  before_action :set_rack_attack_user
  before_action :authenticate_request

  attr_reader :current_user

  private

  def authenticate_request
    header = request.headers["Authorization"]
    token = header&.split(" ")&.last
    return render json: { error: "Not authorized" }, status: :unauthorized unless token

    decoded = JwtService.decode(token)
    @current_user = User.find_by(id: decoded[:user_id]) if decoded
    render json: { error: "Not authorized" }, status: :unauthorized unless @current_user
  end

  def set_rack_attack_user
    request.env['current_user_id'] = current_user&.id
  end
end 
