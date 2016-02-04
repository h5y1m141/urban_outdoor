class Admin::ItemsController < AdminController
  def index
    @items = Item.includes(:pictures).order("updated_at DESC").all.page(params[:page])
  end
end
