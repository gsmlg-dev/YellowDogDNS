defmodule YellowDog.DNS.ResourceOpt do
  @moduledoc """
  Struct definition for serializing and parsing RFC2671/6891's OPT RR records.

  The corresponding record in `:inet_dns` is `:dns_rr_opt`.
  """

  record = Record.extract(:dns_rr_opt, from_lib: "kernel/src/inet_dns.hrl")
  keys = record |> Enum.map(fn {n, _} -> n end)
  vals = keys |> Enum.map(&{&1, [], nil})
  pairs = Enum.zip(keys, vals)

  defstruct record

  @type t :: %__MODULE__{}

  @doc """
  Converts a `YellowDog.DNS.ResourceOpt` struct to a `:dns_rr_opt` record.
  """
  def to_record(%YellowDog.DNS.ResourceOpt{unquote_splicing(pairs)}) do
    {:dns_rr_opt, unquote_splicing(vals)}
  end

  @doc """
  Converts a `:dns_rr_opt` record into a `YellowDog.DNS.ResourceOpt`.
  """
  def from_record(dns_rr_opt)

  def from_record({:dns_rr_opt, unquote_splicing(vals)}) do
    %YellowDog.DNS.ResourceOpt{unquote_splicing(pairs)}
  end

  def from_record(_), do: nil
end
