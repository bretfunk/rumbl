defmodule RumblWeb.SosView do
  use RumblWeb, :view

  @states_with_api ["Washington"]

  def has_api(state), do: Enum.member?(@states_with_api, state)

  def get_website(state) do
    states = [
      %{
        state: "Missouri",
        url: "https://bsd.sos.mo.gov/BusinessEntity/BESearch.aspx?SearchType=0"
      },
      %{state: "Florida", url: "http://search.sunbiz.org/Inquiry/CorporationSearch/ByName"},
      %{state: "Washington", url: "https://ccfs.sos.wa.gov/"}
    ]

    if state !== "" do
      states
      |> Enum.find(fn map -> map.state === state end)
      |> Map.get(:url)
    end
  end
end
