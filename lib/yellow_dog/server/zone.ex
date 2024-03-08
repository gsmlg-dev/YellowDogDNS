defmodule YellowDog.Server.Zone do
  def findByDomain(%YellowDog.DNS.Query{domain: domain, type: type}) do
    list = domain |> to_string |> String.split(".") |> Enum.reverse()

    case list do
      ["com", "gsmlg" | _] ->
        if type == :a do
          r = %YellowDog.DNS.Resource{
            domain: domain,
            type: type,
            ttl: 600,
            data: {167, 179, 98, 144}
          }

          {:ok, [r]}
        else
          {:nxdomain}
        end

      _ ->
        {:nxdomain}
    end
  end
end
