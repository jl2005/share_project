class StaticPagesController < ApplicationController
  def home
    if signed_in?
      @project_items = current_user.get_projects
    end
  end

  def contact
  end

  def help
  end

  def about 
  end
end
