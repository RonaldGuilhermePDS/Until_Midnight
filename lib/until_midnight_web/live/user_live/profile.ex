defmodule UntilMidnightWeb.UserLive.Profile do
  use UntilMidnightWeb, :live_view

  alias UntilMidnight.Accounts
  alias UntilMidnight.Posts

    @impl true
  def mount(%{"name" => name}, session, socket) do
    socket = assign_defaults(session, socket)
    user = Accounts.profile(name)

    {:ok,
      socket
      |> assign(page: 1, per_page: 15)
      |> assign(user: user)
      |> assign(page_title: "@#{user.name}")
      |> assign_posts(),
      temporary_assigns: [posts: []]}
  end

  defp assign_posts(socket) do
    socket
    |> assign(posts:
      Posts.list_profile_posts(
        page: socket.assigns.page,
        per_page: socket.assigns.per_page,
        user_id: socket.assigns.user.id
      )
    )
  end

  @impl true
  def handle_event("load-more-profile-posts", _, socket) do
    {:noreply, socket |> load_posts}
  end

  defp load_posts(socket) do
    total_posts = socket.assigns.user.posts_count
    page = socket.assigns.page
    per_page = socket.assigns.per_page
    total_pages = ceil(total_posts / per_page)

    if page == total_pages do
      socket
    else
      socket
      |> update(:page, &(&1 + 1))
      |> assign_posts()
    end
  end

  @impl true
  def handle_params(_params, _uri, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action)}
  end

  defp apply_action(socket, :index) do
	  live_action = get_live_action(socket.assigns.user, socket.assigns.current_user)

    socket |> assign(live_action: live_action)
  end

  defp apply_action(socket, :following) do
    following = Accounts.list_following(socket.assigns.user)
    socket |> assign(following: following)
  end

  defp apply_action(socket, :followers) do
    followers = Accounts.list_followers(socket.assigns.user)
    socket |> assign(followers: followers)
  end

  defp get_live_action(user, current_user) do
    cond do
      current_user && current_user == user -> :edit_profile
      current_user -> :follow_component
      true -> :login_btn
    end
  end
end
