defmodule YellowDog.DNS.RCode do
  @moduledoc """
  # DNS RCode
  DNS return code

      Range 	Registration Procedures
      0-3840	IETF Review
      3841-4095	Private Use
      4096-65534	IETF Review
      65535	Reserved (Standards Action)

      RCODE 	Name 	Description 	Reference
      0	NoError	No Error	[RFC1035]
      1	FormErr	Format Error	[RFC1035]
      2	ServFail	Server Failure	[RFC1035]
      3	NXDomain	Non-Existent Domain	[RFC1035]
      4	NotImp	Not Implemented	[RFC1035]
      5	Refused	Query Refused	[RFC1035]
      6	YXDomain	Name Exists when it should not	[RFC2136][RFC6672]
      7	YXRRSet	RR Set Exists when it should not	[RFC2136]
      8	NXRRSet	RR Set that should exist does not	[RFC2136]
      9	NotAuth	Server Not Authoritative for zone	[RFC2136]
      9	NotAuth	Not Authorized	[RFC8945]
      10	NotZone	Name not contained in zone	[RFC2136]
      11	DSOTYPENI	DSO-TYPE Not Implemented	[RFC8490]
      12-15	Unassigned
      16	BADVERS	Bad OPT Version	[RFC6891]
      16	BADSIG	TSIG Signature Failure	[RFC8945]
      17	BADKEY	Key not recognized	[RFC8945]
      18	BADTIME	Signature out of time window	[RFC8945]
      19	BADMODE	Bad TKEY Mode	[RFC2930]
      20	BADNAME	Duplicate key name	[RFC2930]
      21	BADALG	Algorithm not supported	[RFC2930]
      22	BADTRUNC	Bad Truncation	[RFC8945]
      23	BADCOOKIE	Bad/missing Server Cookie	[RFC7873]
      24-3840	Unassigned
      3841-4095	Reserved for Private Use		[RFC6895]
      4096-65534	Unassigned
      65535	Reserved, can be allocated by Standards Action		[RFC6895]

  # Reference
  - [iana](https://www.iana.org/assignments/dns-parameters/dns-parameters.xhtml#dns-parameters-6)
  - [DOMAIN NAMES - IMPLEMENTATION AND SPECIFICATION](https://tools.ietf.org/html/rfc1035)
  - [Domain Name System (DNS) IANA Considerations](https://tools.ietf.org/html/rfc6895)
  """

  @doc """
  # No Error
  [RFC1035](https://tools.ietf.org/html/rfc1035)
  """
  @spec no_error() :: 0
  def no_error(), do: 0

  @doc """
  # Format Error
  """
  def form_err(), do: 1
  @doc """
  # Server Failure
  """
  @spec serv_fail() :: 2
  def serv_fail(), do: 2
  @doc """
  # Non-Existent Domain
  """
  def nx_domain, do: 3
  @doc """
  # Not Implemented
  """
  def not_imp(), do: 4
  @doc """
  # Query Refused
  """
  def refused(), do: 5
  @doc """
  # Name Exists when it should not
  """
  def yx_domain(), do: 6
  @doc """
  # RR Set Exists when it should not
  """
  def yx_rr_set(), do: 7
  @doc """
  # RR Set that should exist does not
  """
  def nx_rr_set(), do: 8
  @doc """
  # Server Not Authoritative for zone
  # Not Authorized
  """
  def not_auth(), do: 9
  @doc """
  # Name not contained in zone
  """
  def not_zone(), do: 10
  @doc """
  # DSO-TYPE Not Implemented
  """
  def dso_type_ni(), do: 11

  @doc """
  # Bad OPT Version
  """
  def bad_vers(), do: 16
  @doc """
  # TSIG Signature Failure
  """
  def bad_sig(), do: 16
  @doc """
  # Key not recognized
  """
  def bad_key(), do: 17
  @doc """
  # Signature out of time window
  """
  def bad_time(), do: 18
  @doc """
  # Bad TKEY Mode
  """
  def bad_mode(), do: 19
  @doc """
  # Duplicate key name
  """
  def bad_name(), do: 20
  @doc """
  # Algorithm not supported
  """
  def bad_alg(), do: 21
  @doc """
  # Bad Truncation
  """
  def bad_trunc(), do: 22
  @doc """
  # Bad/missing Server Cookie
  """
  def bad_cookie(), do: 23


  def get_name(0), do: :no_error
  def get_name(1), do: :form_err
  def get_name(2), do: :serv_fail
  def get_name(3), do: :nx_domain
  def get_name(4), do: :not_imp
  def get_name(5), do: :refused
  def get_name(6), do: :yx_domain
  def get_name(7), do: :yx_rr_set
  def get_name(8), do: :nx_rr_set
  def get_name(9), do: :not_auth
  def get_name(10), do: :not_zone
  def get_name(11), do: :dso_type_ni
  def get_name(16), do: :bad_vers
  # def get_name(16, :opt), do: :bad_vers
  # def get_name(16, :sig), do: :bad_sig
  def get_name(17), do: :bad_key
  def get_name(18), do: :bad_time
  def get_name(19), do: :bad_mode
  def get_name(20), do: :bad_name
  def get_name(21), do: :bad_alg
  def get_name(22), do: :bad_trunc
  def get_name(23), do: :bad_cookie
end
