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

  def check_array(convo_arr)
    if convo_arr
      if convo_arr[0].instance_of? Array
        convo_arr[0]
      else
        convo_arr
      end
    else
      []
    end
  end
end
