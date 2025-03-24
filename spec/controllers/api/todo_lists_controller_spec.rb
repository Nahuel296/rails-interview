require 'rails_helper'

RSpec.describe Api::TodoListsController, type: :controller do
  render_views

  describe 'GET index' do
    let!(:todo_list) { TodoList.create(name: 'Setup RoR project') }

    it 'returns a success code' do
      get :index, format: :json
      expect(response).to have_http_status(:ok)
    end

    it 'returns the correct JSON structure' do
      get :index, format: :json
      json_response = JSON.parse(response.body)

      expect(json_response).to be_an_instance_of(Array)
      expect(json_response.first.keys).to match_array(['id', 'name'])
    end
  end

  describe 'GET show' do
    let!(:todo_list) { TodoList.create(name: 'Test list') }

    it 'returns the requested todo list' do
      get :show, params: { id: todo_list.id }, format: :json
      expect(response).to have_http_status(:ok)
      json_response = JSON.parse(response.body)
      expect(json_response['name']).to eq(todo_list.name)
    end
  end

  describe 'POST create' do
    it 'creates a new todo list' do
      expect {
        post :create, params: { todo_list: { name: 'New List' } }, format: :json
      }.to change(TodoList, :count).by(1)

      expect(response).to have_http_status(:created)
    end
  end

  describe 'PUT update' do
    let!(:todo_list) { TodoList.create(name: 'Old Name') }

    it 'updates the todo list' do
      put :update, params: { id: todo_list.id, todo_list: { name: 'Updated Name' } }, format: :json
      expect(response).to have_http_status(:ok)
      expect(todo_list.reload.name).to eq('Updated Name')
    end
  end

  describe 'DELETE destroy' do
    let!(:todo_list) { TodoList.create(name: 'To be deleted') }

    it 'deletes the todo list' do
      expect {
        delete :destroy, params: { id: todo_list.id }, format: :json
      }.to change(TodoList, :count).by(-1)

      expect(response).to have_http_status(:ok)
    end
  end

  describe 'POST create' do
    it 'returns an error when name is missing' do
      post :create, params: { todo_list: { name: nil } }, format: :json
      expect(response).to have_http_status(:unprocessable_entity)
      json_response = JSON.parse(response.body)
      expect(json_response['error']).to include("Name can't be blank")
    end
  end 
end

RSpec.describe Api::TodoListItemController, type: :controller do
  render_views
  let!(:todo_list) { TodoList.create(name: 'Test List') }
  let!(:todo_item) { TodoListItem.create(description: 'Test Item', completed: false, todo_list_id: todo_list.id) }

  describe 'GET index' do
    it 'returns all todo items for a list' do
      get :index, params: { todo_list_id: todo_list.id }, format: :json
      expect(response).to have_http_status(:ok)
      json_response = JSON.parse(response.body)
      expect(json_response.first['description']).to eq(todo_item.description)
    end
  end

  describe 'POST create' do
    it 'creates a new todo item' do
      expect {
        post :create, params: { todo_list_id: todo_list.id, todo_list_item: { description: 'New Item', completed: false } }, format: :json
      }.to change(TodoListItem, :count).by(1)
      expect(response).to have_http_status(:created)
    end
  end

  describe 'PUT update' do
    it 'updates the todo item' do
      put :update, params: { id: todo_item.id, todo_list_id: todo_list.id, todo_list_item: { description: 'Updated Item' } }, format: :json
      expect(response).to have_http_status(:ok)
      expect(todo_item.reload.description).to eq('Updated Item')
    end
  end

  describe 'DELETE destroy' do
    it 'deletes the todo item' do
      expect {
        delete :destroy, params: { id: todo_item.id, todo_list_id: todo_list.id }, format: :json
      }.to change(TodoListItem, :count).by(-1)
      expect(response).to have_http_status(:ok)
    end
  end

  describe 'GET index' do
    it 'returns message when there are no todo items' do
      todo_list = TodoList.create(name: 'Test List')
      get :index, params: { todo_list_id: todo_list.id }, format: :json
      expect(response).to have_http_status(:ok)
      json_response = JSON.parse(response.body)
      expect(json_response['message']).to eq('There are no items in this list.')
    end
  end

  describe 'POST create' do
    it 'returns error when parameters are missing' do
      todo_list = TodoList.create(name: 'Test List')
      post :create, params: { todo_list_id: todo_list.id, todo_list_item: { description: nil } }, format: :json
      expect(response).to have_http_status(:unprocessable_entity)
      json_response = JSON.parse(response.body)
      expect(json_response['error']).to include("Description can't be blank")
    end
  end

  describe 'PUT update' do
    it 'returns error when todo item is not found' do
      put :update, params: { todo_list_id: 1, id: 999999, todo_list_item: { description: 'Updated description' } }, format: :json
      expect(response).to have_http_status(:not_found)
      json_response = JSON.parse(response.body)
      expect(json_response['error']).to eq("Couldn't find TodoListItem with 'id'=999999")
    end
  end

  describe 'DELETE destroy' do
    it 'returns error when todo item is not found' do
      delete :destroy, params: { todo_list_id: 1, id: 999999 }, format: :json
      expect(response).to have_http_status(:not_found)
      json_response = JSON.parse(response.body)
      expect(json_response['error']).to eq("Couldn't find TodoListItem with 'id'=999999")
    end
  end

  describe 'POST create' do
    it 'creates a new todo item' do
      todo_list = TodoList.create(name: 'Test List')
      post :create, params: { todo_list_id: todo_list.id, todo_list_item: { description: 'New Task', completed: false } }, format: :json
      expect(response).to have_http_status(:created)
      json_response = JSON.parse(response.body)
      expect(json_response['description']).to eq('New Task')
      expect(json_response['completed']).to eq(false)
    end
  end
  
  describe 'PUT update' do
    it 'updates an existing todo item' do
      todo_list = TodoList.create(name: 'Test List')
      todo_item = TodoListItem.create(description: 'Old Description', completed: false, todo_list_id: todo_list.id)
      put :update, params: { todo_list_id: todo_list.id, id: todo_item.id, todo_list_item: { description: 'Updated Description', completed: true } }, format: :json
      expect(response).to have_http_status(:ok)
      json_response = JSON.parse(response.body)
      expect(json_response['description']).to eq('Updated Description')
      expect(json_response['completed']).to eq(true)
    end
  end

  describe 'DELETE destroy' do
    it 'deletes a todo item' do
      todo_list = TodoList.create(name: 'Test List')
      todo_item = TodoListItem.create(description: 'Task to delete', completed: false, todo_list_id: todo_list.id)
      delete :destroy, params: { todo_list_id: todo_list.id, id: todo_item.id }, format: :json
      expect(response).to have_http_status(:ok)
      json_response = JSON.parse(response.body)
      expect(json_response['message']).to eq('Item deleted correctly.')
    end
  end 
end
