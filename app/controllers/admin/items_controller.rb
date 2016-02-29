class Admin::ItemsController < AdminController
  before_action :set_item, only: [:edit, :destroy, :update]
  def index
    @items = Item.includes(:pictures).order("updated_at DESC").all.page(params[:page])
  end

  def edit
    if(@item.tags.count == 0)
      @item.tags.build
    else
      @item
    end
  end

  def update
    tag_values = item_params[:tags_attributes]['0']['name'].split(",")
    tags = tag_values.map{|tag_name| Tag.where(name: tag_name).first_or_create(name: tag_name) }
    @item.tags = []
    @item.tags.push(tags)
    if @item.save
      redirect_to admin_items_path, notice: '更新が完了しました'
    else
      redirect_to edit_admin_article(@item), notice: '更新できません'
    end
  end

  private
  def set_item
    @item = Item.find(params[:id])
  end
  def item_params
    params.require(:item).permit(:name, :url , :original_price, :discounted, :discount_price, :description, tags_attributes: [:id, :name])
  end
end
