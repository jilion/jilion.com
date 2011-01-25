module Admin::JobsHelper

  def job_state(job)
    case job.state
    when 'new'
      "Draft"
    else
      job.state.humanize
    end
  end

end
