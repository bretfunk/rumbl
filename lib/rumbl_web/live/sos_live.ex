defmodule RumblWeb.SosLive do
  use Phoenix.LiveView
  alias RumblWeb.SosView

  @moduledoc """
  live Secretary of State lookup
  """

  # moving the states to maps from a list no longer lets the selected state display in the dropdown button
  # but not always, no idea what is happening
  @states [
    %{state: "", url: ""},
    %{state: "Missouri", api: ""},
    %{state: "Florida", api: ""},
    %{
      state: "Washington",
      api:
        "https://www.sos.wa.gov/corps/search_results.aspx?name_type=starts_with&name=Seattle+Sounders&format=json"
    }
  ]
  # @states ["Missouri", "Florida", "Washington"]

  def render(assigns) do
    SosView.render("sos_template.html", assigns)
  end

  def mount(_session, socket) do
    socket =
      socket
      |> assign(:states, @states)
      |> assign(:state, "")
      |> assign(:search, "")
      |> assign(:results, [])

    {:ok, socket}
  end

  def handle_event("states", %{"state" => state}, socket) do
    {:noreply, assign(socket, :state, state)}
  end

  def handle_event("search", %{"api" => api}, socket) do
    {:noreply, assign(socket, :search, api["search"])}
  end

  def handle_event("api", %{"search" => search}, socket) do
    url =
      "https://www.sos.wa.gov/corps/search_results.aspx?name_type=starts_with&name=#{
        format_api(search)
      }&format=json"

    {:noreply, assign(socket, :results, "searching...")}

    result =
      get(url)
      |> elem(1)
      |> Map.get(:results)
      |> Map.get(:result)

    {:noreply, assign(socket, :results, result)}
  end

  def get(url, headers \\ []) do
    url
    |> HTTPoison.get(headers)
    |> case do
      {:ok, %{body: raw, status_code: code}} -> {code, raw}
      {:error, %{reason: reason}} -> {:error, reason}
    end
    |> (fn {ok, body} ->
          body
          |> Poison.decode(keys: :atoms)
          |> case do
            {:ok, parsed} -> {ok, parsed}
            _ -> {:error, body}
          end
        end).()
  end

  def format_api(search) do
    search
    |> String.trim()
    |> String.replace(" ", "+")
  end
end
