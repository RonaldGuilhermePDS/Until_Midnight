defmodule UntilMidnightWeb.RenderHelpers do
  import Phoenix.LiveView.Helpers

  def selected_link?(current_uri, menu_link) when current_uri == menu_link do
    "text-secondary font-semibold border-r-2 border-secondary"
  end

  def selected_link?(_current_uri, _menu_link) do
    "text-white"
  end

  def live_modal(component, opts) do
    path = Keyword.fetch!(opts, :return_to)
    width = Keyword.fetch!(opts, :width)
    modal_opts = [id: :modal, return_to: path, width: width, component: component, opts: opts]
    live_component(UntilMidnightWeb.ModalComponent, modal_opts)
  end
end
