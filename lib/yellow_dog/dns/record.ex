defmodule YellowDog.DNS.Record do
  @moduledoc """
  Struct definition for serializing and parsing YellowDog.DNS records.
  """

  record = Record.extract(:dns_rec, from_lib: "kernel/src/inet_dns.hrl")
  keys = record |> Enum.map(fn {n, _} -> n end)
  vals = keys |> Enum.map(&{&1, [], nil})
  pairs = Enum.zip(keys, vals)

  defstruct record
  @type t :: %__MODULE__{}

  @doc """
  Converts a `YellowDog.DNS.Record` struct to a `:dns_rec` record.
  """
  def to_record(struct) do
    header = YellowDog.DNS.Header.to_record(struct.header)
    queries = Enum.map(struct.qdlist, &YellowDog.DNS.Query.to_record/1)
    answers = Enum.map(struct.anlist, &YellowDog.DNS.Resource.to_record/1)
    additional = Enum.map(struct.arlist, &YellowDog.DNS.Resource.to_record/1)

    _to_record(%{struct | header: header, qdlist: queries, anlist: answers, arlist: additional})
  end

  defp _to_record(%YellowDog.DNS.Record{unquote_splicing(pairs)}) do
    {:dns_rec, unquote_splicing(vals)}
  end

  @doc """
  Converts a `:dns_rec` record into a `YellowDog.DNS.Record`.
  """
  def from_record(dns_rec)

  def from_record({:dns_rec, unquote_splicing(vals)}) do
    struct = %YellowDog.DNS.Record{unquote_splicing(pairs)}

    header = YellowDog.DNS.Header.from_record(struct.header)
    queries = Enum.map(struct.qdlist, &YellowDog.DNS.Query.from_record(&1))

    answers =
      Enum.map(struct.anlist, &YellowDog.DNS.Resource.from_record(&1))
      |> Enum.reject(&is_nil/1)

    # authority = Enum.map(struct.nslist, &YellowDog.DNS.Resource.from_record(&1))
    # |> Enum.reject(&is_nil/1)

    additional =
      Enum.map(struct.arlist, &YellowDog.DNS.Resource.from_record(&1))
      |> Enum.reject(&is_nil/1)

    %{struct | header: header, qdlist: queries, anlist: answers, arlist: additional}
  end

  @doc """
  Decodes a binary record into a `YellowDog.DNS.Record` struct.
  """
  @spec decode(binary) :: YellowDog.DNS.Record.t()
  def decode(data) do
    {:ok, record} = :inet_dns.decode(data)
    from_record(record)
  end

  @doc """
  Serializes a `YellowDog.DNS.Record` into its binary representation.
  """
  def encode(struct) do
    :inet_dns.encode(to_record(struct))
  end
end
