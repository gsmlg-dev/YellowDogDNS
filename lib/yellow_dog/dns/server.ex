defmodule YellowDog.DNS.Server do
  @moduledoc """
  YellowDog.DNS server based on `GenServer`.
  """

  @callback handle(YellowDog.DNS.Record.t(), {:inet.ip(), :inet.port()}) :: YellowDog.DNS.Record.t()

  defmacro __using__(_) do
    quote [] do
      use GenServer

      @doc """
      Start YellowDog.DNS.Server` server.

      ## Options

      * `:port` - set the port number for the server
      """
      def start_link(name: name, port: port) do
        GenServer.start_link(name, [port])
      end

      def init([port]) do
        socket = YellowDog.Socket.UDP.open!(port, as: :binary, mode: :active)
        IO.puts("DNS Server listening at #{port}")

        # accept_loop(socket, handler)
        {:ok, %{port: port, socket: socket}}
      end

      def handle_info({:udp, client, ip, wtv, data}, state) do
        record = YellowDog.DNS.Record.decode(data)
        response = handle(record, client)
        YellowDog.Socket.Datagram.send!(state.socket, YellowDog.DNS.Record.encode(response), {ip, wtv})
        {:noreply, state}
      end
    end
  end
end
