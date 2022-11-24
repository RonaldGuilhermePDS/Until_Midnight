defmodule UntilMidnightWeb.FeedComponent do
  use UntilMidnightWeb, :live_component

  alias UntilMidnight.Uploaders.Avatar
  alias UntilMidnight.Comments
  alias UntilMidnight.Comments.Comment

  @impl true
  def mount(socket) do
    {:ok,
      socket
      |> assign(changeset: Comments.change_comment(%Comment{})),
      temporary_assigns: [comments: []]}
  end

  @impl true
  def handle_event("save", %{"comment" => comment_param}, socket) do
    %{"body" => body} = comment_param
    current_user = socket.assigns.current_user
    post = socket.assigns.post

    if body == "" do
      {:noreply, socket}
    else
      comment = Comments.create_comment(current_user, post, comment_param)
      {:noreply,
        socket
        |> update(:comments, fn comments -> [comment | comments] end)
        |> assign(changeset: Comments.change_comment(%Comment{}))}
    end
  end
end
