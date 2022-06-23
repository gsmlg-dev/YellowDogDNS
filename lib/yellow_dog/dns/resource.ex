defmodule YellowDog.DNS.Resource do
  @moduledoc """
  Struct definition for serializing and parsing YellowDog.DNS resource.
  """

  require Record

  record = Record.extract(:dns_rr, from_lib: "kernel/src/inet_dns.hrl")
  keys = record |> Enum.map(fn {n, _} -> n end)
  vals = keys |> Enum.map(&{&1, [], nil})
  pairs = Enum.zip(keys, vals)

  defstruct record
  @type t :: %__MODULE__{}

  @doc """
  Converts a `YellowDog.DNS.Resource` or `YellowDog.DNS.ResourceOpt` struct to a `:dns_rr` or
  `:dns_rr_opt` record.
  """
  def to_record(resource)

  def to_record(%YellowDog.DNS.Resource{unquote_splicing(pairs)}) do
    {:dns_rr, unquote_splicing(vals)}
  end

  def to_record(%YellowDog.DNS.ResourceOpt{} = rr_opt) do
    YellowDog.DNS.ResourceOpt.to_record(rr_opt)
  end

  @doc """
  Converts a `:dns_rr` or `:dns_rr_opt` record into a `YellowDog.DNS.Resource` or
  `YellowDog.DNS.ResourceOpt`.
  """
  def from_record(record)

  def from_record(record) when Record.is_record(record, :dns_rr) do
    _from_record(record)
  end

  def from_record(record) when Record.is_record(record, :dns_rr_opt) do
    YellowDog.DNS.ResourceOpt.from_record(record)
  end

  def from_record(_), do: nil

  defp _from_record({:dns_rr, unquote_splicing(vals)}) do
    %YellowDog.DNS.Resource{unquote_splicing(pairs)}
  end
end
