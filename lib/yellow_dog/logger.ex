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

  @spec reqsponse(String.t()) :: :ok
  def reqsponse(message) do
    Logger.info("reqsponse: " <> message)
  end

  @spec forward(String.t()) :: :ok
  def forward(message) do
    Logger.info("forward: " <> message)
  end
end
