class AssignmentPdf < Prawn::Document

  include AssignmentsHelper

  def initialize(assignment, view)
    super({:page_layout => :landscape})
    @assignment = assignment
    @view = view
    stroke_color 'e00000'
    assignment_title_page
    assignment_plan_page
    print_issues
  end

  def assignment_title_page
    move_down 250
    text "Assignment: #{@assignment.product.name}", :size => 25, :style => :bold
    if (@assignment.test_plan.present?)
      text "#{@assignment.test_plan.name}", :size => 15
    else
      text "#{@assignment.stencil.name}", :size => 15
    end
    move_down 20
    text "Version: #{@assignment.version.version}"
    move_cursor_to 10
    text "Generated by TestCaseDB", :size => 9
  end

  def assignment_plan_page
    start_new_page
    if (@assignment.test_plan.present?)
      text "<b>Test Plan:</b> #{@assignment.test_plan.name}", :inline_format => true
    else
      text "<b>Stencil:</b> #{@assignment.stencil.name}", :inline_format => true
      text "<b>Test plan(s):</b>", :inline_format => true
      @assignment.stencil.stencil_test_plans.each do |stencil_test_plan|
        text "#{stencil_test_plan.test_plan.name} on #{stencil_test_plan.device.name}", :size => 15, :indent_paragraphs => 20
      end
    end
    text "<b>Notes</b>: #{@assignment.notes}", :inline_format => true
    text "<b>Version:</b> #{@assignment.version.version}", :inline_format => true
    text "<b>Product:</b> #{@assignment.product.name}", :inline_format => true
    move_down 20
    text "Test Cases", :style => :bold
    stroke_horizontal_rule
    move_down 10
    print_test_cases_list
  end

  def print_issues
    issues = issues_list(@assignment)
    if (issues.any?)
      start_new_page
      text "Issues", :size => 15, :style => :bold
      stroke_horizontal_rule
      stroke_color '000000'
      move_down 10
      issues.each do |issue|
        text "<b>Issue:</b> #{issue[0]}", :size => 12, :inline_format => true
        text "<b>Name:</b> #{issue[1][:name]}", :size => 12, :inline_format => true
        text "<b>Status:</b> #{issue[1][:status]}", :size => 12, :inline_format => true
        move_down 5
      end
      move_down 5
      stroke_horizontal_rule
      move_down 20
    end
  end

  def print_test_cases_list
    table list_test_cases do
      row(0).font_style = :bold
      self.row_colors = ["EEEEEE", "FFFFFF"]
      self.header = true
      self.column_widths={0 => 150, 2 => 60, 4 => 60}
    end
  end

  def list_test_cases()
    [["Name", "Category", "Version", "Description", "Result", "Date"]] +
    @assignment.results.order.map do |result|
      time = result.executed_at.blank? ? "" : result.executed_at.strftime("%F %T")
      [result.test_case.name, @view.CategoryPathName(result.test_case.category_id), result.test_case.version, result.test_case.description, result.result, time]
    end
  end
end