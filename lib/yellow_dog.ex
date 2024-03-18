defmodule YellowDog do
  @moduledoc """
  Documentation for `YellowDog`.
  """

  @banner_text File.read!("#{:code.priv_dir(:yellow_dog)}/banner.txt")

  @doc false
  def banner do
    @banner_text
  end
end
