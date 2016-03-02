describe Admin::ItemsController, type: :controller do
  let(:user) { create(:user) }
  let(:brand) { create(:brand) }  
  let(:item) { create(:item, brand_id: brand.id) }
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
    # let(:request) { put :update, id: item.id, item: attributes_for(:item)}
    # it_returns_http_status(302)
    # it_redirects_to('/admin/items')
  end
  describe "destroyアクションについて" do
    let(:request) { delete :destroy, id: item.id }
    it_returns_http_status(302)
    it_redirects_to('/admin/items')
  end
end
