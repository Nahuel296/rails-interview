module Api
    class TodoListItemController < ApplicationController
        # GET /api/todos/:id
        def show
            @todo_list_item = TodoListItem.find(params[:id])
    
            if @todo_list_item
                render json: @todo_list_item, status: :ok
            else
                render json: { error: "Item does not exist." }, status: :not_found
            end
        end

        # GET /api/todolists/:todo_list_id/todos
        def index
            @todo_list_items = TodoListItem.where(todo_list_id: params[:todo_list_id])
          
            if @todo_list_items.empty?
                render json: { message: "There are no items in this list." }, status: :ok
            else
                render json: @todo_list_items, status: :ok
            end
        end          
    
        # POST /api/todolists/:todo_list_id/todos
        def create
            @todo_list_id = params[:todo_list_id]
            @todo_list_item_params = params.require(:todo_list_item).permit(:description, :completed)
            @todo_list_item_params[:todo_list_id] = @todo_list_id
            @todo_list_item = TodoListItem.new(@todo_list_item_params)
            @todo_list_item = TodoListItem.create!(@todo_list_item_params)
            render json: @todo_list_item, status: :created
        end
    
        # PUT /api/todolists/:todo_list_id/todos/:id
        def update
            @todo_list_id = params[:todo_list_id]
            @todo_list_item_params = params.require(:todo_list_item).permit(:description, :completed)
            @todo_list_item_params[:todo_list_id] = @todo_list_id
            @todo_list_item = TodoListItem.find(params[:id])
            @todo_list_item.update!(@todo_list_item_params)
            render json: @todo_list_item, status: :ok
        end
    
        # DELETE /api/todolists/:todo_list_id/todos/:id
        def destroy
            @todo_list_item = TodoListItem.find(params[:id])
            @todo_list_item.destroy!
            render json: { message: "Item deleted correctly." }, status: :ok
        end
    end
end
