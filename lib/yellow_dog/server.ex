defmodule YellowDog.Server do
  @moduledoc """
  YellowDog DNS Server
  """
  alias YellowDog.Logger, as: YLog
  use Application

  @impl true
  def start(_type, _args) do
    config = Application.get_env(:yellow_dog, YellowDog.Server)
    port = Keyword.get(config, :port, 5353)

    children = [
      {YellowDog.Server.NameServer, [name: YellowDog.Server.NameServer, port: port]}
    ]

    YLog.general("\n\n#{YellowDog.banner()}\n\n")

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: YellowDog.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
