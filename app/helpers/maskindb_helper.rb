module MaskindbHelper
  def mprop(prop_name, title = nil)
    content_tag :tr do
      result = content_tag(:th) do
        title || prop_name.to_s.humanize
      end
      result += content_tag(:td) do
        @maskindb_entry[prop_name] if @maskindb_entry
      end
      result
    end
  end
end
