class HomeController < ApplicationController
  def index
  end

  def logged
    @logged = { status: user_signed_in? }
  end
end
