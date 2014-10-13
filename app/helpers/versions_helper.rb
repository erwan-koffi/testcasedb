module VersionsHelper

  def list_ticket_versions()
    versions = Array.new
    products = product_list
    products.each do
      |product|
      versions << { :id => product[2], :versions => Ticket.project_version(product[1].to_s) }
    end
    versions[0][:versions].collect { |v| [v[:name], v[:id]] }.sort
  end

  def ticket_version_name(id)
    ids = []
    ticket_version = {}
    if(id.present?)
      ids.push(id)
      ticket_version = Ticket.versions_info(ids)
      ticket_version[id]
    end
    if(ticket_version.blank?)
      ticket_version[id] = {}
      ticket_version[id][:name] = ""
      ticket_version[id][:description] = ""
      ticket_version[id]
    end
  end

end
