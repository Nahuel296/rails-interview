module Api
  class TodoListsController < ApplicationController

    # GET /api/todolists
    def index
      @todo_lists = TodoList.all

      respond_to :json
    end

    # GET /api/todolists/:id
    def show
      @todo_list = TodoList.find(params[:id])

      respond_to :json
    end

    # POST /api/todolists
    def create
      @todo_list_params = params.require(:todo_list).permit(:name)
      @todo_list = TodoList.new(@todo_list_params)
      if @todo_list.save
        render json: @todo_list, status: :created
      else
        render json: @todo_list.errors, status: :unprocessable_entity
      end
    end

     # PUT /api/todolists/:id
     def update
      @todo_list_params = params.require(:todo_list).permit(:name)
      @todo_list = TodoList.find(params[:id])
      if @todo_list.update(@todo_list_params)
        render json: @todo_list
      else
        render json: @todo_list.errors, status: :unprocessable_entity
      end
    end

     # DELETE /api/todolists/:id
     def destroy
      @todo_list = TodoList.find(params[:id])
      if @todo_list.destroy
        head :no_content
      else
        render json: { error: 'Error al borrar'}, status: :unprocessable_entity
      end
    end
  end
end
