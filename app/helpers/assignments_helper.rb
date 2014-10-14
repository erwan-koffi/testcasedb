module AssignmentsHelper
  def test_plans_list(assignment)
    if assignment.id
      if assignment.test_plan_id
        TestPlan.where(:product_id => assignment.product_id).order('name').collect {|p| [ p.name + " | Version " + p.version.to_s, p.id ]}
      else
        ["None"]
      end
    elsif !assignment.product_id.blank?
      TestPlan.where(:product_id => assignment.product_id).order('name').collect {|p| [ p.name + " | Version " + p.version.to_s, p.id ]}
    else
      []
    end
  end
  
  def stencils_list(assignment)
    if assignment.id
      if assignment.stencil_id
        Stencil.where(:product_id => assignment.product_id).order('name').collect {|s| [ s.name + " | Version " + s.version.to_s, s.id ]}
      else
        ["None"]
      end
    elsif !assignment.product_id.blank?
      Stencil.where(:product_id => assignment.product_id).order('name').collect {|s| [ s.name + " | Version " + s.version.to_s, s.id ]}
    else
      []
    end
  end
  
  def ticket_issues(project_id)
    if(project_id.present?)
      issues = Ticket.project_issues(project_id)
      issues.sort_by { |issue| issue[:id].to_i }.reverse.collect { |item| [item[:id] + " " + item[:name], item[:id]]  }
    else
      issues = {}
    end
  end

  def issues_list(assignment)
    if assignment.id
      if assignment.issues
        Ticket.bug_status(assignment.issues.split(','))
      else
        []
      end
    end
  end

  def version_list(product_id)
    if product_id.blank?
      []
    else
      Version.where(:product_id => @assignment.product_id).order("version").collect {|p| [ p.version, p.id ]}
    end
  end
end
