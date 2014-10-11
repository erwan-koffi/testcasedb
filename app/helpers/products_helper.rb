module ProductsHelper
  
  def list_of_users
    # User.order('last_name, first_name').collect {|u| [ u.last_name + ', ' + u.first_name  + ' - ' + u.email, u.id]}
    User.order('last_name, first_name')
  end
  
  def list_of_ticket_product
    Ticket.products().collect {|p| [p[:name], p[:id]]}
  end

  def ticket_product_name(id)
    ids = []
    if(id.present?)
      ids.push(id.to_s)
      ticket_product = Ticket.products_info(ids)
      ticket_product[id][:name]
    else
      ""
    end
  end
end
