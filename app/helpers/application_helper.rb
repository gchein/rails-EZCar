module ApplicationHelper

  def rental_status(status)

    if status == 'archived'
      return 'btn btn-danger'
    elsif status == 'active'
      return 'btn btn-success'
    else
      return 'btn btn-warning'
    end
  end
end
