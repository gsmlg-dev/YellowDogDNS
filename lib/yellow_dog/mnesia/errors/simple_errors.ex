## Simple Error Modules
## --------------------

# NOTE TO SELF:
# Please don't try to be over-efficient and edgy by dynamically
# defining these exceptions from a list of Module names. It looks
# really fucking bad.

defmodule YellowDog.Mnesia.NoTransactionError do
  @moduledoc false
  defexception [:message]
end

defmodule YellowDog.Mnesia.AlreadyExistsError do
  @moduledoc false
  defexception [:message]
end

defmodule YellowDog.Mnesia.DoesNotExistError do
  @moduledoc false
  defexception [:message]
end

defmodule YellowDog.Mnesia.InvalidOperationError do
  @moduledoc false
  defexception [:message]
end
