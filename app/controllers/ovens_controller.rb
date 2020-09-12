class OvensController < ApplicationController
  include ActionController::Live
  SSE_RETRY_TIME = 5000.freeze

  before_action :authenticate_user!

  def index
    @ovens = current_user.ovens
  end

  def show
    @oven = current_user.ovens.find_by!(id: params[:id])
  end

  def empty
    @oven = current_user.ovens.find_by!(id: params[:id])
    if @oven.cookie
      @oven.cookie.update_attributes!(storage: current_user)
    end
    redirect_to @oven, alert: 'Oven emptied!'
  end

  def progress
    @oven = Oven.find(params[:id])
    sse = SSE.new(response.stream)
    response.headers['Content-Type'] = 'text/event-stream'

    return sse.close if @oven.cookie.ready? == false

    template = render_to_string(partial: 'cookie.ready', formats: [:html])
    sse.write(template, retry: SSE_RETRY_TIME)
  rescue IOError
    Rails.Logger.error(IOError)
  ensure
    sse.close if sse.present?
  end
end
