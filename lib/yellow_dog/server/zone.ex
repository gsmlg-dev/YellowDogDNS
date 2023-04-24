defmodule YellowDog.Server.Zone do
  @moduledoc """
  Example implementing YellowDog.DNS.Zone behaviour
  """
  def getZone(domain) do
  end

  def findByDomain(%YellowDog.DNS.Query{domain: domain, type: type}) do
    list = domain |> to_string |> String.split(".") |> Enum.reverse()

    case list do
      ["tld", "sld" | rest] ->
        r = %YellowDog.DNS.Resource{
          domain: domain,
          type: type,
          ttl: 0,
          data: {5, 6, 7, 8}
        }

        if type == :a do
          {:ok, [r]}
        else
          {:ok, []}
        end

      ["com", "gsmlg" | rest] ->
        r = %YellowDog.DNS.Resource{
          domain: domain,
          type: type,
          ttl: 0,
          data: {1, 2, 3, 4}
        }

        {:ok, [r]}

      _ ->
        {:nxdomain}
    end
  end
end
