class StringHelper
  def strip_tags(word)
    ActionController::Base.helpers.strip_tags(word)
  end
end