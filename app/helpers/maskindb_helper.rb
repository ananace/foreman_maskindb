# frozen_string_literal: true

module MaskindbHelper
  def mprop(prop_name, title = nil)
    content_tag :tr do
      result = content_tag(:th) do
        title || prop_name.to_s.humanize
      end
      result += content_tag(:td) do
        data = (@maskindb_entry ? @maskindb_entry[prop_name] : nil)
        case data
        when Hash
          data[:name] || data[:type] || data[:username]
        when String
          data
        else
          'N/A'
        end
      end
      result
    end
  end
end
