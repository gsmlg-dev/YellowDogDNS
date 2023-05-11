defmodule YellowDog.DNS.Server do
  @moduledoc """
  YellowDog.DNS server based on `GenServer`.
  """

  @callback handle(YellowDog.DNS.Record.t(), {:inet.ip(), :inet.port()}) :: YellowDog.DNS.Record.t()

  defmacro __using__(_) do
    quote [] do
      use GenServer
      require Logger
      @doc """
      Start YellowDog.DNS.Server` server.

      ## Options

      * `:port` - set the port number for the server
      """
      def start_link(name: name, port: port) do
        GenServer.start_link(name, [port])
      end

      def init([port]) do
        {:ok, %{port: port, socket: nil}, {:continue, :open_port}}
      end

      @impl true
      def handle_continue(:open_port, %{port: port} = state) do
        socket = YellowDog.Socket.UDP.open!(port, as: :binary, mode: :active)
        Logger.info("YellowDog.DNS.Server started on socket #{inspect(socket)}")
        # accept_loop(socket, handler)
        {:noreply, %{state | socket: socket}}
      end

      @impl true
      def handle_info({:udp, client, ip, wtv, data}, %{socket: socket} = state) do
        record = YellowDog.DNS.Record.decode(data)

        Task.async(fn ->
          response = handle(record, client)
          YellowDog.Socket.Datagram.send!(socket, YellowDog.DNS.Record.encode(response), {ip, wtv})
        end) |> Task.ignore()

        {:noreply, state}
      end
    end
  end
end
