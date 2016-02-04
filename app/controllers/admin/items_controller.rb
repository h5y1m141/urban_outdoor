class Admin::ItemsController < AdminController
  before_action :set_item, only: [:edit, :destroy, :update]
  def index
    @items = Item.includes(:pictures).order("updated_at DESC").all.page(params[:page])
  end

  def edit
  end

  private
  def set_item
    @item = Item.find(params[:id])
  end
end
