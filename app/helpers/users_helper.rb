module UsersHelper

  def admin_logged_in?
    @current_user.present? && @current_user.admin?
  end

  def show_nav_bar?
    @current_user.present?
  end

  def form_back_link
    params[:action] == 'new' && !params[:user].present? ?
        link_to('Or login', login_path) :
        link_to('Back', params[:user] == 'new' ? users_path : welcome_path)
  end

  def field_for(form, field_name, input_type = :text_field)
    error = @user.errors[field_name].first

    content_tag :div, class: "form-group#{' has-error' if error }" do
      form.label(field_name, class: 'control-label') + (
      field_name == :birthday ?
        content_tag(:div, class: 'birthday-field') {form.send(input_type, field_name, class: 'form-control', start_year: 1900, end_year: Date.current.year)} :
        form.send(input_type, field_name, class: 'form-control') ) +
      content_tag(:span, "#{field_name.to_s.humanize} #{error}", class: 'error-msg')
    end
  end

  def awesome_icon(name)
    %Q(<i class="fa fa-#{name}" aria-hidden="true"></i>).html_safe
  end
end
