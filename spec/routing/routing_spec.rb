RSpec.describe StaticPagesController, type: :routing do
  describe 'Routing' do
    it_routes_to(:get, '/', 'static_pages#index')
    it_routes_to(:get, '/about', 'static_pages#about')
  end
end

RSpec.describe ItemsController, type: :routing do
  describe 'Routing' do
    it_routes_to(:get, '/items', 'items#index')
    it_routes_to(:get, '/items/1', 'items#show', id: '1')
    it_routes_to(:get, '/items/new', 'items#new')
    it_routes_to(:put, '/items/1', 'items#update', id: '1')
    it_routes_to(:delete, '/items/1', 'items#destroy', id: '1')
    it_routes_to(:get, '/items/1/edit', 'items#edit', id: '1')
  end
end

RSpec.describe UsersController, type: :routing do
  describe 'Routing' do
    it_routes_to(:get, 'users', 'users#index')
    it_routes_to(:post, 'users', 'users#create')
    it_routes_to(:get, 'users/new', 'users#new')
    it_routes_to(:get, 'users/1', 'users#show', id: '1')
    it_routes_to(:put, 'users/1', 'users#update', id: '1')
    it_routes_to(:delete, 'users/1', 'users#destroy', id: '1')
    it_routes_to(:get, 'users/1/edit', 'users#edit', id: '1')
  end
end
