class TasksController < ApplicationController
  before_action :set_task, only: [:destroy, :edit, :update]

  def index
    @tasks = Task.all.order(deadline: :asc)
  end

  def new
    @task = Task.new
  end

  def create
    @task = Task.new(task_params)

    if @task.save
      redirect_to tasks_url, notice: 'Task successfully created.'
    else
      render :new
    end
  end

  def edit; end

  def update
    if @task.update(task_params)
      redirect_to tasks_url, notice: 'Task successfully updated.'
    else
      flash.now[:notice] = 'Task failed to update.'
      render :edit
    end
  end

  def destroy
    @task.destroy
    redirect_to tasks_url, notice: 'Task successfully destroyed.'
  end

  private

  def set_task
    @task = Task.find(params[:id])
  end

  def task_params
    params.require(:task).permit(:title, :description, :deadline)
  end
end
