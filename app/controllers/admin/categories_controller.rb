module Admin
  class CategoriesController < ApplicationController
    # Adding Basic Authentication for security
    http_basic_authenticate_with name: ENV['ADMIN_USERNAME'], password: ENV['ADMIN_PASSWORD']

    def index
      # Fetch all categories to display on the admin categories page
      @categories = Category.all
    end

    def new
      # Create a new category instance for the form
      @category = Category.new
    end

    def create
      # Create a new category with form data
      @category = Category.new(category_params)
      if @category.save
        redirect_to admin_categories_path, notice: 'Category was successfully created.'
      else
        render :new
      end
    end

    private

    def category_params
      # Permit only the `name` attribute for category creation
      params.require(:category).permit(:name)
    end
  end
end
