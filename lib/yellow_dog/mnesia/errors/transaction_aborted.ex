defmodule YellowDog.Mnesia.TransactionAborted do
  defexception [:message]

  @moduledoc false

  # Raise a YellowDog.Mnesia.TransactionAborted
  defmacro raise(reason) do
    quote(bind_quoted: [reason: reason]) do
      raise YellowDog.Mnesia.TransactionAborted,
        message: "Transaction aborted with: #{inspect(reason)}"
    end
  end
end
