module ApplicationHelper
  def format_category(homework)
    case homework.tutor_category
    when "a_plus"
      "Best Tutors"
    when "cheko"
      "Great Tutors"
    when "standard"
      "Standard Tutors"
    else
      " "
    end
  end
end
