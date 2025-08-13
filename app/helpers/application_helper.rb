module ApplicationHelper
  def sortable(column, title = nil)
    title ||= column.titleize
    direction = (column == @sort_column && @sort_direction == 'asc') ? 'desc' : 'asc'
    link_to title, { sort: column, direction: direction }, class: "text-white text-decoration-none"
  end
end