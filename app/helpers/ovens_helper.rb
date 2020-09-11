module OvensHelper
  def show_cookie_filling(cookie)
    return "no fillings" if cookie.fillings.blank?
    cookie.fillings
  end
end
