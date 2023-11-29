module Users::ProfessorsHelper
  def options_for_school
    options = School.all.collect {|p| [ p.name, p.id ] }
    options << ['Others', 'others']
    # you can define your own logic for selected value.
    selected = !@professor.nil? ? @professor.school_id : 1
    options_for_select(options, selected)
  end
end
