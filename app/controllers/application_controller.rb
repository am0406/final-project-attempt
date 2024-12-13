class ApplicationController < ActionController::Base
  skip_forgery_protection
end

class PagesController < ApplicationController
  def home
  end
end

