class ProjectsController < ApplicationController
  before_action :signed_in_user, only: [:new, :create, :update, :destroy]
  before_action :correct_user,   only: :destroy

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

  def destroy
    @relation.destroy
    #@project.destroy
    redirect_to root_url
  end

  def show
    puts self
    if is_share
      all_users = User.all
      @users= Hash[all_users.collect{|u| [u.id, u.name]}]
    end
    if params[:current_project_name]
      @current_project_name = params[:current_project_name]
    end
    projects = current_user.get_projects
    @projects_name = projects.keys
    @current_project_name ||= @projects_name[0]
    @current_project ||= projects[@current_project_name]
  end

  def switch
    #TODO use session
    if is_share
      all_users = User.all
      @users = Hash[all_users.collect{|u| [u.id, u.name]}]
    end
    @current_project_name = params[:current_project_name]
    projects = current_user.get_projects
    @projects_name = projects.keys
    @current_project_name ||= @projects_name[0]
    @current_project ||= projects[@current_project_name]
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
    user_id = params[:user][:id]
    episodes = params[:episode][:episode_ids]
    episodes.each do |e|
      r = Relationship.new
      r.user_id = user_id
      r.project_id = e
      r.save
    end
  end
  def is_share=(s)
    @is_share = s
  end
  def is_share
    @is_share ||= false
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
