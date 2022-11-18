defmodule UntilMidnightWeb.RenderHelpers do
  def selected_link?(current_uri, menu_link) when current_uri == menu_link do
    "text-secondary font-semibold border-r-2 border-secondary"
  end

  def selected_link?(_current_uri,  _menu_link) do
    "text-white"
  end
end
