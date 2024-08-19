# frozen_string_literal: true

module Api
  module V1
    class CommentsController < AdminController
      before_action :set_comment, only: [:show, :update, :destroy]
      before_action :set_task, only: [:index, :create]

      def index
        @comments = @task.comments

        render json: @comments
      end


      def show
        render json: @comment
      end


      def create
        @comment = @task.comments.new(comment_params)
        @comment.user = @current_user

        if @comment.save
          render json: @comment, status: :created
        else
          render json: @comment.errors, status: :unprocessable_entity
        end
      end


      def update
        if @comment.update(comment_params)
          render json: @comment
        else
          render json: @comment.errors, status: :unprocessable_entity
        end
      end

      def destroy
        @comment.destroy
        head :no_content
      end

      private

      def set_comment
        @comment = Comment.find(params[:id])
      end

      def set_task
        @task = Task.find(params[:task_id])
      end

      def comment_params
        params.require(:comment).permit(:content)
      end
    end
  end
end
