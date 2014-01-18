class HomeController < ApplicationController
  def index
    redirect_to watches_path if user_signed_in?
  end
end
