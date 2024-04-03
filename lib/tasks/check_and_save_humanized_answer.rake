namespace :humanize do

  desc 'humanize answer using undetectable ai api'
  task undetected: :environment do

    1.upto(9) do |iteration|
      start_time = DateTime.now
      Undetectable.check_and_save_humanized_answer
      end_time = DateTime.now
      wait_time = 60 - ((end_time - start_time) * 24 * 60 * 60).to_i
      sleep wait_time if wait_time > 0
    end

  end

end