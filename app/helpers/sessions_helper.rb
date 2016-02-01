module SessionsHelper

	def log_in(user)
    session[:user_id] = user.id
  end

  def log_out 
    session.delete(:user_id)
    @current_user = nil
  end

  def logged_in?
    !current_user.nil?
  end

  def activated_member? 
    logged_in? && current_user.activated
  end

  def on_log_in_page
    if params["controller"] === "sessions" && params["action"] === "new"
      return true
    end
    false
  end

  def is_current_user(user)
  	current_user && user.id === current_user.id
  end

  def is_current_user_id(userid)
    logged_in? && userid === current_user.id
  end

  def current_user
    @current_user ||= User.find_by(id: session[:user_id])
  end

  def get_fav_events(user)
    if logged_in?
      events = UserEvent.where(:user_id => user.id).paginate(page: params[:page])
      events = events.map{ |a| a.event_id }
      events = events.uniq
    else 
      events = []
    end 
    events
  end

  def is_admin
  	logged_in? && current_user.admin? 
  end

  def current_user_n_admin_id(userid)
    (is_current_user_id(userid) || is_admin)
  end

  def only_current_user_n_admin(user)
    (is_current_user(user) || is_admin)
  end
end
