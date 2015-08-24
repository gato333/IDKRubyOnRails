class PagesController < ApplicationController
	protect_from_forgery

  def home

  end

  def do

  end

  def eat

  end

  def random

  end

  def results 
  	if params.include?("source")
  		@title = params["source"]
  	else 
  		redirect_to :action => 'error', :error_msg => "You must submit from either the EAT or DO pages to get Results. You can't just jump to the end!"
  	end
  end

  def error 
  	if params.include?(:error_msg)
  		@error_msg = params[:error_msg]
  	else 
  		@error_msg = "SOMETHING HAPPENED, dont really know what"
  	end
  end

end
