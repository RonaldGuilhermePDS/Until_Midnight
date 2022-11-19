defmodule UntilMidnightWeb.UserLive.Profile.FollowingComponent do
  use UntilMidnightWeb, :live_component

  alias UntilMidnight.Uploaders.Avatar

  def mount(_params, session, socket) do
    socket = assign(session, socket)

    {:ok, socket}
  end
end
