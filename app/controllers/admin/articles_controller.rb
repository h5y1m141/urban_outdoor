class Admin::ArticlesController < AdminController
  before_action :set_article, only: [:edit, :destroy, :update, :load_elements]
  
  def index
    @articles = Article.includes(:pictures).order("updated_at DESC").all.page(params[:page]).per(params[:per_page])
  end

  def new
    @article = Article.new
  end

  def create
    @article = Article.new(article_param)
    if @article.save
      @article
    else
      render json: {}, status: 400
    end
  end

  def edit
  end

  def load_elements
  end

  private
  def set_article
    @article = Article.find(params[:id])
  end

  def article_param
    params.permit('title', 'publish_status', 'elements_attributes': ['tag_name', 'element_data'])
  end
end
