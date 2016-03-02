describe Admin::ItemsController, type: :controller do
  let(:user) { create(:user) }
  let(:brand) { create(:brand) }  
  let(:item) { create(:item, brand_id: brand.id) }
  let(:tags) { create_list(:tag, 2) }
  before(:each) { login_user(user) }

  describe "indexアクションについて" do
    let(:request) { get :index }
    it_renders_template(:index)
  end

  describe "editアクションについて" do
    let(:request) { get :edit, id: item.id }
    it_renders_template(:edit)
  end

  describe "updateアクションについて" do
    let(:response) { put :update, { id: item.id, thumbnail: '{"id": 10000}', tags: tags } }
    it 'thumbnailのIDが更新される' do
      expect(item.thumbnail_id).to eq 1
      response
      item.reload
      expect(item.thumbnail_id).to eq 10000
    end
    it_returns_http_status(302)
    it_redirects_to('/admin/items')
  end
  describe "destroyアクションについて" do
    let(:request) { delete :destroy, id: item.id }
    it_returns_http_status(302)
    it_redirects_to('/admin/items')
  end
end
