class ApplicationController < ActionController::API
  before_action :authenticate_request
  attr_reader :current_user

  private

  def authenticate_request
    unless action.include?(request['action']) && controller.include?(request['controller'])
      @current_user = AuthorizeApiRequest.call(request.headers).result
      render json: { error: 'Not Authorized' }, status: 401 unless @current_user
    end
  end

  def action
    %w[create forgot reset]
  end

  def controller
    %w[user password]
  end
end
