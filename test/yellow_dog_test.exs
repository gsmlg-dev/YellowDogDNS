defmodule YellowDogTest do
  use ExUnit.Case
  doctest YellowDog

  test "default load config, no implement yet" do
    assert YellowDog.load_config() == %YellowDog.Config{}
  end
end
