class CategoryController < ApplicationController
  def index
    @categories = current_user.category.all
  end
end
