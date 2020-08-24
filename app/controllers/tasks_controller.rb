class TasksController < ApplicationController
  
  def index
    if logged_in?
      @tasks = current_user.tasks.order(id: :desc).page(params[:page])
    end
  end

  def show
    @task = Task.find(params[:id])
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
    @task = current_user.tasks.find_by(params[:id])
  end

  def update
    @task = current_user.tasks.find_by(params[:id])

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
  
end
