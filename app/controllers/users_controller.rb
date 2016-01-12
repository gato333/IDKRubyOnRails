class UsersController < ApplicationController
	include ApplicationHelper 

	LOGO = ApplicationHelper::LOGO
  DESCRIPTION = ApplicationHelper::DESCRIPTION
  DEFAULT_STATUS = ApplicationHelper::DEFAULT_STATUS

  def new
  	@logo = LOGO
    @description = DESCRIPTION
    @javascriptsArray = ApplicationHelper.includeJavascripts( DEFAULT_STATUS ); 
  end
end
