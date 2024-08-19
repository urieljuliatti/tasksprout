# frozen_string_literal: true

module Api
  module V1
    class TasksController < AdminController
      before_action :set_task, only: [:show, :edit, :update, :destroy]

      # GET /tasks
      def index
        @tasks = Task.all

        render json: @tasks
      end

      # GET /tasks/:id
      def show
        render json: @task
      end

      def edit
      end

      # POST /tasks
      def create
        @task = Task.new(task_params)
        @task.user = @current_user
        if @task.save
          render json: @task, status: :created
        else
          render json: @task.errors, status: :unprocessable_entity
        end
      end

      # PATCH/PUT /tasks/:id
      def update
        @categories = params[:category_ids]
        if @task.update(task_params)

          if params[:category_ids]
            @task.categories = Category.find(params[:category_ids])
          end

          render json: @task
        else
          render json: @task.errors, status: :unprocessable_entity
        end
      end

      # DELETE /tasks/:id
      def destroy
        @task.destroy
        head :no_content
      end

      private

      def set_task
        @task = Task.find(params[:id])
      end

      def task_params
        params.require(:task).permit(:title, :description, :status, :priority, :due_date, :user_id, category_ids: [])
      end
    end
  end
end
