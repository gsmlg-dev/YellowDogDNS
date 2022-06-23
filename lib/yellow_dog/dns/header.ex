defmodule YellowDog.DNS.Header do
  @moduledoc """
  Struct definition for serializing and parsing YellowDog.DNS header.
  """

  record = Record.extract(:dns_header, from_lib: "kernel/src/inet_dns.hrl")
  keys = record |> Enum.map(fn {n, _} -> n end)
  vals = keys |> Enum.map(&{&1, [], nil})
  pairs = Enum.zip(keys, vals)

  defstruct record
  @type t :: %__MODULE__{}

  @doc """
  Converts a `YellowDog.DNS.Header` struct to a `:dns_header` record.
  """
  def to_record(%YellowDog.DNS.Header{unquote_splicing(pairs)}) do
    {:dns_header, unquote_splicing(vals)}
  end

  @doc """
  Converts a `:dns_header` record into a `YellowDog.DNS.Header`.
  """
  def from_record(file_info)

  def from_record({:dns_header, unquote_splicing(vals)}) do
    %YellowDog.DNS.Header{unquote_splicing(pairs)}
  end
end
