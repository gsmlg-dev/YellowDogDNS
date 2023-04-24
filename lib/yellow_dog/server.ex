defmodule YellowDog.Server do
  @moduledoc """
  YellowDog DNS Server
  """
  require Logger
  use Application

  @impl true
  def start(_type, _args) do
    config = Application.get_env(:yellow_dog, YellowDog.Server)
    port = Keyword.get(config, :port, 5353)

    children = [
      {YellowDog.Server.NameServer, [name: YellowDog.Server.NameServer, port: port]}
    ]

    Logger.info("Starting YellowDog Server on port #{port}")

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: YellowDog.Supervisor]
    Supervisor.start_link(children, opts)
  end


end
