module OvensHelper
  def show_cookies(cookies)
    mapper = -> (fillings, count) { cookie_message(fillings, count) }
    cookies.map(&mapper).join('<br>').html_safe
  end

  private

  def cookie_message(fillings, count)
    "- #{count} cookies with #{fillings || 'no fillings'}"
  end
end
