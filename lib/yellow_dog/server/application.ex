defmodule YellowDog.Server.Application do
  @moduledoc """
  Example implementing YellowDog.DNS.Server behaviour
  """
  use Application

  @impl true
  def start(_type, _args) do
    config = Application.get_env(:yellow_dog_server, YellowDog.Server.Server)
    port = Keyword.get(config, :port, 5353)

    children = [
      {YellowDog.Server.Server, [name: YellowDog.Server.Server, port: port]}
    ]

    Supervisor.start_link(children, strategy: :one_for_one, name: YellowDog.Server.Supervisor)
  end
end
