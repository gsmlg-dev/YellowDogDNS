defmodule YellowDog.Server.NameServer do
  @moduledoc """
  Implementing YellowDog.DNS.Server behaviour
  """
  @behaviour YellowDog.DNS.Server
  use YellowDog.DNS.Server
  require Logger

  def handle(record, _client) do
    # record: %YellowDog.DNS.Record{
    #   anlist: [],
    #   arlist: [%YellowDog.DNS.ResourceOpt{
    #     data: <<0, 10, 0, 8, 97, 227, 140, 70, 17, 115, 176, 108>>,
    #     domain: '.', ext_rcode: 0, type: :opt, udp_payload_size: 4096, version: 0, z: 0
    #   }],
    #   header: %YellowDog.DNS.Header{
    #     aa: false, id: 27018, opcode: :query, pr: false, qr: false, ra: false, rcode: 0, rd: true, tc: false
    #   },
    #   nslist: [],
    #   qdlist: [%YellowDog.DNS.Query{
    #     class: :in,
    #     domain: 'zdns.cn',
    #     type: :aaaa,
    #     unicast_response: false
    #   }]
    # }
    # Logger.info(fn -> "#{inspect(record)}" end)
    query = hd(record.qdlist)
    # query: %YellowDog.DNS.Query{class: :in, domain: 'zdns.cn', type: :a, unicast_response: false}
    Logger.info(fn -> "Query: #{inspect(query)}" end)

    case YellowDog.Server.Zone.findByDomain(query.domain, query.type) do
      {:ok, resourcs} ->
        %{
          record
          | header: %{record.header | qr: true, ra: false, aa: true},
            anlist: resourcs,
            arlist: []
        }

      {:nxdomain} ->
        %{
          record
          | header: %{record.header | qr: true, ra: false, aa: true, rcode: 3},
            anlist: [],
            arlist: []
        }

      _ ->
        %{
          record
          | header: %{record.header | qr: true, ra: false, aa: true, rcode: 2},
            anlist: [],
            arlist: []
        }
    end
  end
end
