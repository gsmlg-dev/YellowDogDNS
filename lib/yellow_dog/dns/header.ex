defmodule YellowDog.DNS.Header do
  @moduledoc """
  # DNS Header

  The header contains the following fields:

                                      1  1  1  1  1  1
        0  1  2  3  4  5  6  7  8  9  0  1  2  3  4  5
      +--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+
      |                      ID                       |
      +--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+
      |QR|   Opcode  |AA|TC|RD|RA|   Z    |   RCODE   |
      +--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+
      |                    QDCOUNT                    |
      +--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+
      |                    ANCOUNT                    |
      +--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+
      |                    NSCOUNT                    |
      +--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+
      |                    ARCOUNT                    |
      +--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+

  where:

  - `ID`

  A 16 bit identifier assigned by the program that
  generates any kind of query.  This identifier is copied
  the corresponding reply and can be used by the requester
  to match up replies to outstanding queries.

  - `QR`

  A one bit field that specifies whether this message is a
  query (0), or a response (1).

  - `OPCODE`

  A four bit field that specifies kind of query in this
  message.  This value is set by the originator of a query
  and copied into the response.

  - `AA`

  Authoritative Answer - this bit is valid in responses,
  and specifies that the responding name server is an
  authority for the domain name in question section.

  Note that the contents of the answer section may have
  multiple owner names because of aliases.  The AA bit
  corresponds to the name which matches the query name, or
  the first owner name in the answer section.

  - `TC`

  TrunCation - specifies that this message was truncated
  due to length greater than that permitted on the
  transmission channel.

  - `RD`

  Recursion Desired - this bit may be set in a query and
  is copied into the response.  If RD is set, it directs
  the name server to pursue the query recursively.
  Recursive query support is optional.

  - `RA`

  Recursion Available - this be is set or cleared in a
  response, and denotes whether recursive query support is
  available in the name server.

  - `Z`

  Reserved for future use.  Must be zero in all queries
  and responses.

  - `AD`

  The AD bit exists in order to provide a means for a security-aware
  resolver to signal to a security-aware name server that the resolver
  considers authentic data to be more important than unauthenticated
  data.  The AD bit is only intended to provide a signal from the
  resolver to the name server; it is not intended to provide a signal
  from the name server to the resolver.

  [rfc4035]

  - `CD`

  The CD bit exists in order to allow a security-aware resolver to
  disable signature validation in a security-aware name server's
  processing of a particular query.

  [rfc4035]

  - `RCODE`

  Response code - this 4 bit field is set as part of
  responses.

  - `QDCOUNT`

  an unsigned 16 bit integer specifying the number of
  entries in the question section.

  - `ANCOUNT`

  an unsigned 16 bit integer specifying the number of
  resource records in the answer section.

  - `NSCOUNT`

  an unsigned 16 bit integer specifying the number of name
  server resource records in the authority records
  section.

  - `ARCOUNT`

  an unsigned 16 bit integer specifying the number of
  resource records in the additional records section.


  # Reference
  - [iana](https://www.iana.org/assignments/dns-parameters/dns-parameters.xhtml#dns-parameters-5)
  - [DOMAIN NAMES - IMPLEMENTATION AND SPECIFICATION](https://tools.ietf.org/html/rfc1035)
  - [Domain Name System (DNS) IANA Considerations](https://tools.ietf.org/html/rfc6895)
  """

  @type t :: %__MODULE__{
    id: integer(), # ID: 16bit if 0 generate RandomID
    qr: 0 | 1, # QR: 1bit  query (0), or a response (1)
    opcode: integer(), # OPCode: 4bit YellowDog.DNS.OpCode.t(),
    aa: 0 | 1, # AA: 1bit Authoritative Answer
    tc: 0 | 1, # TC: 1bit TrunCation
    rd: 0 | 1, # RD: 1bit Recursion Desired
    ra: 0 | 1, # RA: 1bit Recursion Available
    z: 0 | 1, # Z: 1bit Reserved for future use
    ad: 0 | 1, # AD: 1bit Authenticated Data
    cd: 0 | 1, # CD: 1bit Checking Disabled
    rcode: integer(), # RCode: 4bit YellowDog.DNS.RCode.t(),
    qdcount: integer(), # QDCOUNT: 16bit an unsigned integer specifying the number of entries in the question section.
    ancount: integer(), # ANCOUNT: 16bit an unsigned integer specifying the number of resource records in the answer section.
    nscount: integer(), # NSCOUNT: 16bit an unsigned integer specifying the number of name server resource records in the authority records section.
    arcount: integer() # ARCOUNT: 16bit an unsigned integer specifying the number of resource records in the additional records section.
  }

  defstruct id: nil,
            qr: nil,
            opcode: nil,
            aa: nil,
            tc: nil,
            rd: nil,
            ra: nil,
            z: 0,
            ad: nil,
            cd: nil,
            rcode: nil,
            qdcount: 1,
            ancount: 0,
            nscount: 0,
            arcount: 0

  @doc """
  # build a DNS header
  """
  def to_buffer(header = %YellowDog.DNS.Header{}) do
    <<header.id::16, header.qr::1, header.opcode::4, header.aa::1, header.tc::1, header.rd::1,
      header.ra::1, header.z::1, header.ad::1, header.cd::1, header.rcode::4, header.qdcount::16,
      header.ancount::16, header.nscount::16, header.arcount::16>>
  end

  def from_buffer(
        <<id::16, qr::1, opcode::4, aa::1, tc::1, rd::1, ra::1, z::1, ad::1, cd::1, rcode::4,
          qdcount::16, ancount::16, nscount::16, arcount::16>> = _buffer
      ) do
    %YellowDog.DNS.Header{
      id: id,
      qr: qr,
      opcode: opcode,
      aa: aa,
      tc: tc,
      rd: rd,
      ra: ra,
      z: z,
      ad: ad,
      cd: cd,
      rcode: rcode,
      qdcount: qdcount,
      ancount: ancount,
      nscount: nscount,
      arcount: arcount
    }
  end
end
