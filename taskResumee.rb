require_relative 'togglV8'
require 'awesome_print'
require 'time'


class Toggl
  #
  # tasks = tog.get_time_entries(Time.new(2014, month, 01, 0, 0, 0, "+00:00"), Time.new(2014, month+1, 01, 0, 0, 0, "+00:00"))
  # client_id_from_task = tog.get_client_id(task[0])
  #
  def get_client_id(task)
    if task["pid"]
      project = get_project(task["pid"])
      return project["cid"]
    else
      return nil
    end
  end

  # For a given month, it adds the number of hours for each client
  #
  def taskResumee(month)
    result = {}
    tasks = get_time_entries(Time.new(2014, month, 01, 0, 0, 0, "+00:00"), Time.new(2014, month+1, 01, 0, 0, 0, "+00:00"))
    tasks.each do |task|
      client_id = get_client_id(task)
      if client_id
        if !result[client_id]
          result[client_id] = 0;
        end
        result[client_id] += task["duration"];
      end
    end
    return result
  end
end

if __FILE__ == $0
  tog = Toggl.new("65f1338de0f9eff25adf6cee4f128b7b")

  resumee = tog.taskResumee( 6)
  resumee.each do |k,v|
    time = Time.at(v).utc.strftime("%H:%M:%S")
    client = tog.get_client(k)["name"]
    print client +" "+time +"\n"
  end
end