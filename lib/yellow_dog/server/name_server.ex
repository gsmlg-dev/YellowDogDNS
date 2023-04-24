defmodule YellowDog.Server.NameServer do
  @moduledoc """
  Implementing YellowDog.DNS.Server behaviour
  """
  @behaviour YellowDog.DNS.Server
  use YellowDog.DNS.Server
  require Logger

  @default_forwarder Application.compile_env(:yellow_dog, YellowDog.Server) |> Keyword.get(:default_forwarder)

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

    case YellowDog.Server.Zone.findByDomain(query) do
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
        forward_lookup(record)

      _ ->
        %{
          record
          | header: %{record.header | qr: true, ra: false, aa: true, rcode: 2},
            anlist: [],
            arlist: []
        }
    end
  end

  # default_forwarder
  def forward_lookup(record, dns_server \\ @default_forwarder, proto \\ :udp) do
    encoded_record = record |> YellowDog.DNS.Record.encode()
    response_data =
      case proto do
        :udp ->
          client = YellowDog.Socket.UDP.open!(0)

          YellowDog.Socket.Datagram.send!(client, encoded_record, dns_server)

          {data, _server} = YellowDog.Socket.Datagram.recv!(client, timeout: 5_000)

          :gen_udp.close(client)

          data

        :tcp ->
          # Set our packet mode to be 2, which indicates there is a 2 byte, big
          # endian length field on our packets sent and recv'd
          socket = YellowDog.Socket.TCP.connect!(dns_server, timeout: 5_000, packet: 2)

          :ok = YellowDog.Socket.Stream.send(socket, encoded_record)

          data = YellowDog.Socket.Stream.recv!(socket)

          YellowDog.Socket.Stream.close!(socket)

          data
      end

    YellowDog.DNS.Record.decode(response_data)
  end
end
