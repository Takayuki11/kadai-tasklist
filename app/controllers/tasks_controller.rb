class TasksController < ApplicationController
  before_action :require_user_logged_in, only: [:show,:new,:edit]
  before_action :correct_user, only: [:show,:edit]
  
  def index
    if logged_in?
      @tasks = current_user.tasks.order(id: :desc).page(params[:page])
    end
  end

  def show
    if logged_in?
      @task = current_user.tasks.find(params[:id])
    end
  end

  def new
    if logged_in?
      @task = current_user.tasks.build
    end
  end

  def create
    @task = current_user.tasks.build(task_params)
    
    if @task.save
      flash[:success] = "taskが正常に作成されました。 "
      redirect_to root_path
    else
      flash.now[:danger] = "taskが正常に作成されませんでした。"
      render :new
    end
  end

  def edit
    if logged_in?
      @task = current_user.tasks.find(params[:id])
    end
  end

  def update
    @task = current_user.tasks.find(params[:id])

    if @task.update(task_params)
      flash[:success] = 'task は正常に更新されました'
      redirect_to @task
    else
      flash.now[:danger] = 'task は更新されませんでした'
      render :edit
    end
  end

  def destroy
    @task = current_user.tasks.find(params[:id])
    @task.destroy
    
    flash[:success] = "taskは正常に削除されました。"
    redirect_to tasks_url
  end
  
  private
  
  def task_params
    params.require(:task).permit(:status, :content)
  end
  
  def correct_user
    @task = current_user.tasks.find_by(id: params[:id])
    unless @task
      redirect_to root_url
    end
  end
end
