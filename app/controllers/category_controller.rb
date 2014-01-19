class CategoryController < ApplicationController
  before_filter :authenticate_user!
  respond_to :html, :json
  def list
    @categories = current_user.category.all
    respond_with(@categories, :layout => false)
  end
end
