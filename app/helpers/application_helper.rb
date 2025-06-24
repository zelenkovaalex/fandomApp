module ApplicationHelper
  def nav_link(text, url, html_options = {})
    is_active = current_page?(url)

    classes = [html_options[:class], ('active' if is_active)].compact.join(' ')

    link_to(text, url, html_options.merge(class: classes))
  end

  def active_menu_class_for(controller_name)
    'active' if controller.controller_name == controller_name
  end
end