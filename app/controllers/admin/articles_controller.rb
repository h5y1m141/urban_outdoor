class Admin::ArticlesController < AdminController
  before_action :set_article, only: [:edit, :destroy, :update]
  def index
    @articles = Article.includes(:pictures).order("updated_at DESC").all.page(params[:page])
  end

  def new
    @article = Article.new
  end

  def edit
  end

  private
  def set_article
    @article = Article.find(params[:id])
  end
end
