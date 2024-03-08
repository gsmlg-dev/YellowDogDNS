defmodule YellowDog.Logger do
  @moduledoc """
  YellowDog Logger Module
  """
  require Logger

  @spec general(String.t()) :: :ok
  def general(message) do
    Logger.info("general: " <> message)
  end

  @spec query(String.t()) :: :ok
  def query(message) do
    Logger.info("query: " <> message)
  end

  @spec response(String.t()) :: :ok
  def response(message) do
    Logger.info("response: " <> message)
  end

  @spec forward(String.t()) :: :ok
  def forward(message) do
    Logger.info("forward: " <> message)
  end
end
