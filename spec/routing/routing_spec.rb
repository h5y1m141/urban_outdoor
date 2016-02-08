RSpec.describe StaticPagesController, type: :routing do
  describe 'Routing' do
    it_routes_to(:get, '/', 'static_pages#index')
    it_routes_to(:get, '/about', 'static_pages#about')
  end
end

RSpec.describe ItemsController, type: :routing do
  describe 'Routing' do
    it_routes_to(:get, '/items', 'items#index')
    it_routes_to(:post, '/items', 'items#create')
    it_routes_to(:get, '/items/1', 'items#show', id: '1')
    it_routes_to(:get, '/items/new', 'items#new')
    it_routes_to(:put, '/items/1', 'items#update', id: '1')
    it_routes_to(:delete, '/items/1', 'items#destroy', id: '1')
    it_routes_to(:get, '/items/1/edit', 'items#edit', id: '1')
  end
end

describe Admin::ItemsController, type: :routing do
  it_routes_to(:get, '/admin/items', 'admin/items#index', format: :html )
  it_routes_to(:get, '/admin/items/1/edit', 'admin/items#edit', id: '1', format: :html )
  it_routes_to(:patch, '/admin/items/1', 'admin/items#update', id: '1', format: :html )
  it_routes_to(:delete, '/admin/items/1', 'admin/items#destroy', id: '1', format: :html )
end

describe Admin::ArticlesController, type: :routing do
  it_routes_to(:get, '/admin/articles', 'admin/articles#index', format: :html )
  it_routes_to(:get, '/admin/articles/1/edit', 'admin/articles#edit', id: '1', format: :html )
  it_routes_to(:patch, '/admin/articles/1', 'admin/articles#update', id: '1', format: :html )
  it_routes_to(:delete, '/admin/articles/1', 'admin/articles#destroy', id: '1', format: :html )
end
