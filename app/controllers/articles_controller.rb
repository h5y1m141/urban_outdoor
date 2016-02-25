class ArticlesController < ApplicationController
  def index
    
  end

  def show
  end

  def preview
    @article = Article.find_by_preview_key(params[:preview_key])
  end
end
