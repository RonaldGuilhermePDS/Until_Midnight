defmodule UntilMidnightWeb do
  @moduledoc """
  The entrypoint for defining your web interface, such
  as controllers, views, channels and so on.

  This can be used in your application as:

      use UntilMidnightWeb, :controller
      use UntilMidnightWeb, :view

  The definitions below will be executed for every view,
  controller, etc, so keep them short and clean, focused
  on imports, uses and aliases.

  Do NOT define functions inside the quoted expressions
  below. Instead, define any helper function in modules
  and import those modules here.
  """

  def controller do
    quote do
      use Phoenix.Controller, namespace: UntilMidnightWeb

      import Plug.Conn
      import UntilMidnightWeb.Gettext
      alias UntilMidnightWeb.Router.Helpers, as: Routes
    end
  end

  def view do
    quote do
      use Phoenix.View,
        root: "lib/until_midnight_web/templates",
        namespace: UntilMidnightWeb

      # Import convenience functions from controllers
      import Phoenix.Controller,
        only: [get_flash: 1, get_flash: 2, view_module: 1, view_template: 1]

      # Include shared imports and aliases for views
      unquote(view_helpers())
    end
  end

  def live_view do
    quote do
      use Phoenix.LiveView,
        layout: {UntilMidnightWeb.LayoutView, "live.html"}

      unquote(view_helpers())

      import UntilMidnightWeb.LiveHelpers

      alias UntilMidnight.Accounts

      alias UntilMidnight.Accounts.User

      @impl true
      def handle_info(%{event: "logout_user", payload: %{user: %User{id: id}}}, socket) do
        with %User{id: ^id} <- socket.assigns.current_user do
          {:noreply,
            socket
            |> redirect(to: "/")
            |> put_flash(:info, "Logged out successfully.")
          }
        else
          _any -> {:noreply, socket}
        end
      end

      @impl true
      def handle_params(params, uri, socket) do
        if Map.has_key?(params, "name") do
          %{"name" => name} = params
          user = Accounts.profile(name)
          {:noreply,
          socket
          |> assign(current_uri_path: URI.parse(uri).path)
          |> assign(user: user, page_title: "#{user.name} (@#{user.name})")}
        else
          {:noreply,
            socket
            |> assign(current_uri_path: URI.parse(uri).path)}
        end
      end
    end
  end

  def live_component do
    quote do
      use Phoenix.LiveComponent

      unquote(view_helpers())
    end
  end

  def component do
    quote do
      use Phoenix.Component

      unquote(view_helpers())
    end
  end

  def router do
    quote do
      use Phoenix.Router

      import Plug.Conn
      import Phoenix.Controller
      import Phoenix.LiveView.Router
    end
  end

  def channel do
    quote do
      use Phoenix.Channel
      import UntilMidnightWeb.Gettext
    end
  end

  defp view_helpers do
    quote do
      # Use all HTML functionality (forms, tags, etc)
      use Phoenix.HTML

      # Import LiveView and .heex helpers (live_render, live_patch, <.form>, etc)
      import Phoenix.LiveView.Helpers

      # Import basic rendering functionality (render, render_layout, etc)
      import Phoenix.View

      import UntilMidnightWeb.ErrorHelpers
      import UntilMidnightWeb.Gettext
      import UntilMidnightWeb.RenderHelpers

      alias UntilMidnightWeb.Router.Helpers, as: Routes
    end
  end

  @doc """
  When used, dispatch to the appropriate controller/view/etc.
  """
  defmacro __using__(which) when is_atom(which) do
    apply(__MODULE__, which, [])
  end
end
