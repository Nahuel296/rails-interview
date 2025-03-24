module Api
    class TodoListItemController < ApplicationController
        # GET /api/todos/:id
        def show
            @todo_list_item = TodoListItem.find(params[:id])
    
            respond_to :json
        end

        # GET /api/todolists/:todo_list_id/todos
        def index
            @todo_list_items = TodoListItem.where(todo_list_id: params[:todo_list_id])
          
            if @todo_list_items.any?
              render json: @todo_list_items, status: :ok
            else
              head :no_content
            end
          end          
    
        # POST /api/todolists/:todo_list_id/todos
        def create
            @todo_list_id = params[:todo_list_id]
            @todo_list_item_params = params.require(:todo_list_item).permit(:description, :completed)
            @todo_list_item_params[:todo_list_id] = @todo_list_id
            @todo_list_item = TodoListItem.new(@todo_list_item_params)
            if @todo_list_item.save
                render json: @todo_list_item, status: :created
            else
                render json: @todo_list_item.errors, status: :unprocessable_entity
            end
        end
    
        # PUT /api/todolists/:todo_list_id/todos/:id
        def update
            @todo_list_id = params[:todo_list_id]
            @todo_list_item_params = params.require(:todo_list_item).permit(:description, :completed)
            @todo_list_item_params[:todo_list_id] = @todo_list_id
            @todo_list_item = TodoListItem.find(params[:id])
            if @todo_list_item.update(@todo_list_item_params)
                render json: @todo_list_item
            else
                render json: @todo_list_item.errors, status: :unprocessable_entity
            end
        end
    
        # DELETE /api/todolists/:todo_list_id/todos/:id
        def destroy
            @todo_list_item = TodoListItem.find(params[:id])
            if @todo_list_item.destroy
                head :no_content
            else
                render json: { error: 'Error al borrar item'}, status: :unprocessable_entity
            end
        end
    end
end
