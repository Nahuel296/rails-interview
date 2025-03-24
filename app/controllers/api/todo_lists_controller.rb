module Api
  class TodoListsController < ApplicationController

    # GET /api/todolists
    def index
      @todo_list = TodoList.all
          
      if @todo_list.empty?
          render json: { message: "There are no lists." }, status: :ok
      else
          render json: @todo_list, status: :ok
      end
    end

    # GET /api/todolists/:id
    def show
      @todo_list = TodoList.find(params[:id])

      render json: @todo_list, status: :ok
    end

    # POST /api/todolists
    def create
      @todo_list_params = params.require(:todo_list).permit(:name)
      @todo_list = TodoList.create!(@todo_list_params)
      render json: @todo_list, status: :created
    end

     # PUT /api/todolists/:id
     def update
      @todo_list_params = params.require(:todo_list).permit(:name)
      @todo_list = TodoList.find(params[:id])
      @todo_list.update!(@todo_list_params)
      render json: @todo_list, status: :ok
    end

     # DELETE /api/todolists/:id
     def destroy
      @todo_list = TodoList.find(params[:id])
      @todo_list.destroy!
      render json: { message: "Task list successfully deleted." }, status: :ok
    end
  end
end
