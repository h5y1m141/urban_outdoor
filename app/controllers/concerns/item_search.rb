module ItemSearch
  def search_items_by_parameters(query_parameter)
    Item.includes(:pictures).includes(:brand)
      .order("updated_at DESC")
      .ransack(
        price_gteq: query_parameter[:min_price],
        price_lteq: query_parameter[:max_price]
      )
  end  
end
