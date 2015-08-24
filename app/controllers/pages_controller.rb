class PagesController < ApplicationController
  def home

  end

  def do

  end

  def eat

  end

  def random

  end

  def results 
  	if params? 
  		@title = params["source"]
  	else 
  		@title = "NEITHER"
  	end
  end

end
