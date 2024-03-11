defmodule YellowDog.DNS.Server do
  @moduledoc """
  YellowDog.DNS server based on `GenServer`.
  """

  @callback handle(YellowDog.DNS.Record.t(), {:inet.ip(), :inet.port()}) ::
              YellowDog.DNS.Record.t()

  defmacro __using__(_) do
    quote [] do
      use GenServer
      alias YellowDog.Logger, as: YLog

      @doc """
      Start YellowDog.DNS.Server` server.

      ## Options

      * `:port` - set the port number for the server
      """
      def start_link(name: name, port: port) do
        GenServer.start_link(name, [port])
      end

      @impl true
      def init([port]) do
        {:ok, %{port: port, socket: nil}, {:continue, :open_port}}
      end

      @impl true
      def handle_continue(:open_port, %{port: port} = state) do
        socket = YellowDog.Socket.UDP.open!(port, as: :binary, mode: :active)
        YLog.general("YellowDog.DNS.Server started on port #{port} #{inspect(socket)}")
        # accept_loop(socket, handler)
        {:noreply, %{state | socket: socket}}
      end

      @impl true
      def handle_info({:udp, client, ip, port, data}, %{socket: socket} = state) do
        query = YellowDog.DNS.Record.decode(data)
        {a,b,c,d} = ip
        ip_str = "#{a}.#{b}.#{c}.#{d}:#{port}"
        YLog.query("Query from #{ip_str} payload: #{inspect(query)}")

        Task.async(fn ->
          response = handle(query, client)

          YellowDog.Socket.Datagram.send!(
            socket,
            YellowDog.DNS.Record.encode(response),
            {ip, port}
          )

          YLog.response("Response sent to #{ip_str} for #{inspect(query)} with: #{inspect(response)}")
        end)
        |> Task.ignore()

        {:noreply, state}
      end
    end
  end
end
