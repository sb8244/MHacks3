class UserController < ApplicationController
  def logged
    @logged = { status: user_signed_in? }
  end
end
