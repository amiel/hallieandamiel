module TagsHelper
  def title_for_category(category)
    # TODO: I18n
    case category
    when 'user'
      'By Photographer'
    when 'person'
      'By Person'
    else
      'By Category'
    end
  end
end
