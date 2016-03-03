module ItemSearchModule
  def search_items_by_parameters(query_parameter)
    Item.includes(:pictures).includes(:brand)
      .order("updated_at DESC")
      .ransack(query_parameter)
  end  
end
