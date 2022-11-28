# frozen_string_literal: true

module MaskindbHelper
  def mprop(prop_name, title = nil)
    content_tag :tr do
      result = content_tag(:th) { title || prop_name.to_s.humanize }
      result += content_tag(:td) { read_prop(@maskindb_entry, prop_name) }

      result
    end
  end

  private

  def read_prop(prop, prop_name)
    data = prop&.fetch(prop_name, nil)
    case data
    when Hash
      data[:name] || data[:type] || data[:username]
    when String
      data
    else
      'N/A'
    end
  end
end
