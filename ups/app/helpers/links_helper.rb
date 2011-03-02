module LinksHelper
  def linklist(category_id)
    cat = Category.find_by_id category_id
    if cat.nil?
      cat_name = CategoryName.find_by_name category_id
      cat = cat_name.category if cat_name.present?
    end

    if cat.present?
      return raw("<h2>" + category_name(cat) + ":</h2>") + make_html_list(cat.links.map do |link|
        link_to link.title, link.href
      end)
    end
  end
end
