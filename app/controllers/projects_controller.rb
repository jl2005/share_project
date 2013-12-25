class ProjectsController < ApplicationController
  before_action :signed_in_user, only: [:new, :create, :edit, :update, :destroy, :show, :switch, :share, :unshare, :share_to]
  before_action :correct_user,   only: [:destroy]

  def new
    @project = Project.new()
  end

  def create
    @project = current_user.projects.build(project_params)
    if @project.save
      @relation = current_user.relationships.build(project_id: @project.id)
      if @relation.save
        flash[:success] = "project created!"
        redirect_to root_url
        return
      else
        @project.destory
      end
    end
    render 'new'
  end

  def edit
    #TODO
  end

  def destroy
    @relation.destroy
    #@project.destroy
    redirect_to root_url
  end

  def show
    self.init_user
    if !self.init_project_params
      redirect_to root_path
    end
  end

  def switch
    self.init_user
    if !self.init_project_params
      redirect_to root_path
    end
    respond_to do |format|
      format.html {redirect_to show_path}
      format.js
    end
  end

  def share
    self.is_share = true
    redirect_to project_show_path
  end

  def unshare
    self.is_share = false
    redirect_to project_show_path
  end

  def share_to
    puts params.has_key?(:user)
    puts params.has_key?(:episode)
    if !params.has_key?(:user) || !params.has_key?(:episode)
      flash[:error] = 'NOT choose User or Projects'
      redirect_to project_show_path
      return
    end
    user_id = params[:user][:id]
    episodes = params[:episode][:episode_ids]
    array = []
    episodes.each do |e|
      if Relationship.exists?({:user_id=>user_id, :project_id=>e})
        array.push(e)
        next
      end
      r = Relationship.new
      r.user_id = user_id
      r.project_id = e
      r.save
    end
    if !array.empty?
      flash[:note] = "User " + user_id + " already has project " + array.to_json
    end
    redirect_to project_show_path
    return
  end

  def init_user
    if is_share
      @users= Hash[User.all.collect{|u| [u.id, u.name]}]
      @users.delete_if{|k, v| k == current_user.id}
    end
  end

  def init_project_params
    projects = current_user.get_projects
    @projects_name = projects.keys
    if params[:current_project_name]
      session[:current_project_name] = params[:current_project_name]
      @current_project_name = params[:current_project_name]
    elsif session[:current_project_name]
      @current_project_name = session[:current_project_name]
    elsif @projects_name
      @current_project_name = @projects_name[0]
    else
      return false
    end
    @current_project = projects[@current_project_name]
    return true
  end

private
    def project_params
      params.require(:project).permit(:name, :parameter1, :parameter2, :comment)
    end

    def correct_user
      @project = current_user.projects.find_by(id: params[:id])
      redirect_to root_url if @project.nil?
    end
end
