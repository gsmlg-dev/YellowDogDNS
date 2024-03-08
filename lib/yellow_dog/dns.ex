defmodule YellowDog.DNS do
  alias YellowDog.Logger, as: YLog

  @doc """
  Resolves the answer for a YellowDog.DNS query.

  ## Examples

      iex> YellowDog.DNS.resolve("gsmlg.org")
      {:ok, [{167, 179, 98, 144}]}

      iex> YellowDog.DNS.resolve("gsmlg.net", :txt)
      {:ok, [['v=spf1 +mx ~all']]}

      iex> YellowDog.DNS.resolve("gsmlg.org", :a, {"1.2.4.8", 53})
      {:ok, [{167, 179, 98, 144}]}

      iex> YellowDog.DNS.resolve("gsmlg.org", :a, {"1.2.4.8", 53}, :tcp)
      {:ok, [{167, 179, 98, 144}]}

  """
  @spec resolve(String.t(), atom, {String.t(), :inet.port()}, :tcp | :udp) ::
          {atom, :inet.ip()} | {atom, list} | {atom, atom}
  def resolve(domain, type \\ :a, dns_server \\ {"1.2.4.8", 53}, proto \\ :udp) do
    case query(domain, type, dns_server, proto).anlist do
      answers when is_list(answers) and length(answers) > 0 ->
        data =
          answers
          |> Enum.map(& &1.data)
          |> Enum.reject(&is_nil/1)

        {:ok, data}

      _ ->
        {:error, :not_found}
    end
  end

  @doc """
  Queries the YellowDog.DNS server and returns the result.

  ## Examples

  Queries for A records:

      iex> YellowDog.DNS.query("gsmlg.org")

  Queries for the MX records:

      iex> YellowDog.DNS.query("gsmlg.org", :mx)

  Queries for A records, using OpenYellowDog.DNS:

      iex> YellowDog.DNS.query("gsmlg.org", :a, { "1.2.4.8", 53})


  Queries for A records, using OpenYellowDog.DNS, with TCP:

      iex> YellowDog.DNS.query("gsmlg.org", :a, { "1.2.4.8", 53}, :tcp)

  """
  @spec query(String.t(), atom, {String.t(), :inet.port()}, :tcp | :udp) ::
          YellowDog.DNS.Record.t()
  def query(domain, type \\ :a, dns_server \\ {"1.2.4.8", 53}, proto \\ :udp) do
    record = %YellowDog.DNS.Record{
      header: %YellowDog.DNS.Header{rd: true},
      qdlist: [%YellowDog.DNS.Query{domain: to_charlist(domain), type: type, class: :in}]
    }

    encoded_record = YellowDog.DNS.Record.encode(record)
    YLog.forward("Querying #{domain} for #{type} using #{proto} to #{inspect(dns_server)}")

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
