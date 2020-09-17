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
    @sheet = @oven.sheet
    @cookies = Cookie.in_sheet(@sheet.id).by_fillings if @sheet.present?
  end

  def empty
    @oven = find_user_oven
    cookies = @oven.cookies

    return redirect_to @oven, alert: 'Oven already empty!' if cookies.empty?

    @oven.sheet = nil
    cookies.each { |cookie| cookie.update_attributes!(storage: current_user) }

    current_user.save!
    @oven.save!

    redirect_to @oven, alert: 'Oven emptied!'
  end

  def progress
    sse = SSE.new(response.stream)
    response.headers['Content-Type'] = 'text/event-stream'

    oven = find_user_oven

    return sse.close if oven.sheet.blank?
    return sse.close unless oven.sheet.ready?

    template = render_to_string(partial: 'sheet.ready', formats: [:html])
    sse.write(template, retry: SSE_RETRY_TIME)
  rescue => error
    Rails.logger.error(error)
  ensure
    sse.close if sse.present?
  end

  private

  def find_user_oven
    current_user.ovens.find_by!(id: params[:id])
  end
end
