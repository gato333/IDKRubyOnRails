class StringHelper
  def self.strip_tags(word)
    ActionController::Base.helpers.strip_tags(word)
  end
end