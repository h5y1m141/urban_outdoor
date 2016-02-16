describe Admin::ArticlesController, type: :controller do
  let(:user) { create(:user) }
  before(:each) { login_user(user) }

  describe "newアクションについて" do
    let(:request) { get :new }
    it_renders_template(:new)
  end

  describe "createアクションについて" do
    before :each do
      request.env["HTTP_ACCEPT"] = 'application/json'
      
    end
    describe '記事作成のタイトルのみ渡された場合' do
      let(:response) {post :create , { title: '記事コンテンツのタイトル' } }
      it_returns_http_status(200)
      it '返り値にタイトルのデーターが含まれてる' do
        json = JSON.parse(response.body)
        expect(json['title']).to eq '記事コンテンツのタイトル'
      end
    end
    describe '記事の子の要素となるパラメーターが渡された場合' do
      let(:instagram) { FactoryGirl.create(:article_element, :instagram)}
      let(:description) { FactoryGirl.create(:article_element, :description)}
      let(:attributes) do
        [ instagram.attributes.slice('tag_name', 'element_data'),
          description.attributes.slice('tag_name', 'element_data')
        ]
      end

      let(:response) {post :create , { title: '記事にいくつかの要素が含まれてる', elements_attributes: attributes } }
      # it_returns_http_status(200)
      it '記事作後に得られる返り値に記事データーが含まれてる' do
        json = JSON.parse(response.body)
        expect(json['title']).to eq '記事にいくつかの要素が含まれてる'

        expect(json['elements'].length).to eq 2
      end
    end
    describe '必須パラメーターが無い場合' do
      let(:response) {post :create , {title: nil}}
      it_returns_http_status(400)
      it '返り値は空のデーターが返る' do
        json = JSON.parse(response.body)
        expect(json['title']).to eq nil
      end
    end
  end
end
