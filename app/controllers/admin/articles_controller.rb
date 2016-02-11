class Admin::ArticlesController < AdminController
  before_action :set_article, only: [:edit, :destroy, :update]
  def index
    @articles = Article.includes(:pictures).order("updated_at DESC").all.page(params[:page])
  end

  def new
    @article = Article.new
  end

  def create
    article = Article.new(article_param)    
    respond_to do |format|
      format.json do
        if article.save
          render json: article
        else
        end
      end
    end
  end

  def edit
  end

  private
  def set_article
    @article = Article.find(params[:id])
  end

  def article_param
    params.permit('title', 'publish_status', 'elements_attributes': ['tag_name', 'element_data'])
  end
end
