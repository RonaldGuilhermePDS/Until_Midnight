defmodule UntilMidnightWeb.ModalComponent do
  use UntilMidnightWeb, :live_component

  @impl true
  def render(assigns) do
    ~H"""
    <div
      class="fixed top-0 left-0 flex items-center justify-center w-full h-screen bg-primary-1 bg-opacity-50 z-50"
      phx-capture-click="close"
      phx-window-keydown="close"
      phx-key="escape"
      phx-target={@myself}
      phx-page-loading>

      <div class={"#{@width} h-auto bg-white rounded-lg"}>
        <%= live_component @component, @opts %>
      </div>
    </div>
    """
  end

  @impl true
  def handle_event("close", _, socket) do
    {:noreply, push_patch(socket, to: socket.assigns.return_to)}
  end
end
