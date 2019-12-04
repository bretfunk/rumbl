defmodule RumblWeb.SalesLive do
  use Phoenix.LiveView
  alias RumblWeb.SalesView

  def render(assigns) do
    SalesView.render("parent_template.html", assigns)
  end

  def mount(_session, socket) do
    {:ok, assign(socket, :val, 0)}
  end

  def handle_event("inc", _, socket) do
    {:noreply, update(socket, :val, &(&1 + 1))}
  end

  def handle_event("dec", _, socket) do
    {:noreply, update(socket, :val, &(&1 - 1))}
  end
end
