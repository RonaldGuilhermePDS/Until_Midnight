defmodule UntilMidnightWeb.PostLive.LikeComponent do
  use UntilMidnightWeb, :live_component

  alias UntilMidnight.Likes

  @impl true
  def update(assigns, socket) do
    get_btn_status(socket, assigns)
  end

  @impl true
  def render(assigns) do
    ~H"""
    <button
      phx-target={@myself}
      phx-click="toggle-status"
      class="w-8 h-8 focus:outline-none">
      <%= @icon %>
    </button>
    """
  end

  @impl true
  def handle_event("toggle-status", _params, socket) do
    current_user = socket.assigns.current_user
    liked = socket.assigns.liked

    if liked?(current_user.id, liked.likes) do
      unlike(socket, current_user.id, liked)
    else
      like(socket, current_user, liked)
    end
  end

  defp like(socket, current_user, liked) do
    Likes.create_like(current_user, liked)
    send_msg(liked)

    {:noreply,
      socket
      |> assign(icon: unlike_icon(socket.assigns))}
  end

  defp unlike(socket, current_user_id, liked) do
    Likes.unlike(current_user_id, liked)
    send_msg(liked)

    {:noreply,
      socket
      |> assign(icon: like_icon(socket.assigns))}
  end

  defp send_msg(liked) do
    msg = get_struct_msg_atom(liked)
    send(self(), {__MODULE__, msg, liked.id})
  end

  defp get_btn_status(socket, assigns) do
    if liked?(assigns.current_user.id, assigns.liked.likes) do
      get_socket_assigns(socket, assigns, unlike_icon(assigns))
    else
      get_socket_assigns(socket, assigns, like_icon(assigns))
    end
  end

  defp get_socket_assigns(socket, assigns, icon) do
    {:ok,
      socket
      |> assign(assigns)
      |> assign(icon: icon)}
  end

  defp get_struct_name(struct) do
    struct.__struct__
    |> Module.split()
    |> List.last()
    |> String.downcase()
  end

  defp get_struct_msg_atom(struct) do
    name = get_struct_name(struct)
    update_struct_likes = "update_#{name}_likes"
    String.to_atom(update_struct_likes)
  end

  defp like_icon(assigns) do
    ~H"""
      <%= Heroicons.icon("hand-thumb-up", type: "outline", class: "text-white h-8 w-8 cursor-pointer") %>
    """
  end

  defp unlike_icon(assigns) do
    ~H"""
      <%= Heroicons.icon("hand-thumb-up", type: "solid", class: "text-white h-8 w-8 cursor-pointer") %>
    """
  end

  defp liked?(user_id, likes) do
    Enum.any?(likes, fn l ->
      l.user_id == user_id
    end)
  end
end
