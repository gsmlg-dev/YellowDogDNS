defmodule YellowDog do
  @moduledoc """
  Documentation for `YellowDog`.
  """

  @banner_text File.read!("#{:code.priv_dir(:yellow_dog)}/banner.txt")

  @doc false
  def banner do
    @banner_text
  end

  @doc """
  Load config from file

  ## Examples

      iex> YellowDog.load_config()
      %YellowDog.Config{}

  """
  def load_config do
    %YellowDog.Config{}
  end
end
