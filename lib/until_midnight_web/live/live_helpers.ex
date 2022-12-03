defmodule UntilMidnightWeb.LiveHelpers do
  import Phoenix.LiveView

  alias UntilMidnight.Accounts
  alias UntilMidnight.Accounts.User
  alias UntilMidnightWeb.UserAuth

  def assign_defaults(session, socket) do
    if connected?(socket), do: UntilMidnightWeb.Endpoint.subscribe(UserAuth.pubsub_topic())

    socket =
      assign_new(socket, :current_user, fn ->
        find_current_user(session)
      end)

    socket
  end

  defp find_current_user(session) do
    with user_token when not is_nil(user_token) <- session["user_token"],
         %User{} = user <- Accounts.get_user_by_session_token(user_token),
         do: user
  end
end
