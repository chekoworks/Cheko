module ProfessorMetricsHelper

  def additional_grade_to_letter(professor)
    case professor.additional_metric_grade
      when 0
        "C"
      when 25
        "B-"
      when 50
        "B"
      when 75
        "B+"
      when 100
        "A"
      end
    end
end
