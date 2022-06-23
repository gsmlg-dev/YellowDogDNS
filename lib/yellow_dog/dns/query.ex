defmodule YellowDog.DNS.Query do
  @moduledoc """
  Struct definition for serializing and parsing YellowDog.DNS query.
  """

  record = Record.extract(:dns_query, from_lib: "kernel/src/inet_dns.hrl")
  keys = record |> Enum.map(fn {n, _} -> n end)
  vals = keys |> Enum.map(&{&1, [], nil})
  pairs = Enum.zip(keys, vals)

  defstruct record
  @type t :: %__MODULE__{}

  @doc """
  Converts a `YellowDog.DNS.Query` struct to a `:dns_query` record.
  """
  def to_record(%YellowDog.DNS.Query{unquote_splicing(pairs)}) do
    {:dns_query, unquote_splicing(vals)}
  end

  @doc """
  Converts a `:dns_query` record into a `YellowDog.DNS.Query`.
  """
  def from_record(file_info)

  def from_record({:dns_query, unquote_splicing(vals)}) do
    %YellowDog.DNS.Query{unquote_splicing(pairs)}
  end
end
