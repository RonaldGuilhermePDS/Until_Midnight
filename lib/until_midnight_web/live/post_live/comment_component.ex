defmodule UntilMidnightWeb.PostLive.CommentComponent do
  use UntilMidnightWeb, :live_component

  alias UntilMidnight.Uploaders.Avatar

  @impl true
  def render(assigns) do
    ~H"""
    <div class="flex flex-col py-2" id={"comment-#{@comment.id}"}>
      <div class="flex items-start">
        <div class="w-2/12">
          <%= live_redirect to: Routes.user_profile_path(@socket, :index, @comment.user.name) do %>
            <%= img_tag Avatar.get_thumb(@comment.user.avatar),
              class: "w-8 h-8 rounded-full object-cover object-center" %>
          <% end %>
        </div>

        <div class="w-10/12">
          <div class="flex justify-between items-center">
            <%= live_redirect @comment.user.name,
              to: Routes.user_profile_path(@socket, :index, @comment.user.name),
              class: "text-white text-sm font-bold truncate hover:underline" %>

            <div class="text-white text-sm">
              <%= Timex.from_now @comment.inserted_at %>
            </div>
          </div>

          <span class="text-white text-sm">
            <p class="inline break-all">
              <%= @comment.body %>
            </p>
          </span>
        </div>
      </div>

      <div class="flex items-center space-x-2 px-2">
        <%= if @current_user do %>
          <%= live_component UntilMidnightWeb.LikeComponent,
              id: "comment-#{@comment.id}",
              liked: @comment,
              current_user: @current_user,
              w_h: "w-5 h-5" %>
          <div class="text-white text-xs"><%= @comment.total_likes %> Likes</div>
        <% else %>
          <%= link to: Routes.user_session_path(@socket, :new) do %>
            <%= Heroicons.icon("hand-thumb-up", type: "outline", class: "w-5 h-5 text-white cursor-pointer") %>
          <% end %>
        <% end %>
      </div>
    </div>
    """
  end
end
