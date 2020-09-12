class OvensController < ApplicationController
  # Comment this line in order to make RSpec run (Check #9)
  include ActionController::Live

  SSE_RETRY_TIME = 5000.freeze

  before_action :authenticate_user!

  def index
    @ovens = current_user.ovens
  end

  def show
    @oven = find_user_oven
  end

  def empty
    @oven = find_user_oven
    if @oven.cookie
      @oven.cookie.update_attributes!(storage: current_user)
    end
    redirect_to @oven, alert: 'Oven emptied!'
  end

  def progress
    sse = SSE.new(response.stream)
    response.headers['Content-Type'] = 'text/event-stream'

    @oven = find_user_oven

    return sse.close if @oven.cookie.blank?
    return sse.close unless @oven.cookie.ready?

    template = render_to_string(partial: 'cookie.ready', formats: [:html])
    sse.write(template, retry: SSE_RETRY_TIME)
  rescue => error
    Rails.logger.error(error)
  ensure
    sse.close
  end

  private

  def find_user_oven
    current_user.ovens.find_by!(id: params[:id])
  end
end
