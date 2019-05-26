defmodule Monarchive.Keys.KeyGenerator do
  alias Monarchive.Keys.Key
  alias Monarchive.Repo

  @characters "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
  @minimum 56_800_235_584 # this is [1, 0, 0, 0, 0, 0, 0]
  @count 3_464_814_370_623 # this is the cardinality of the set of 7 digit, base 62 numbers.


  def generate_key do
    key = generate_seven_character_key()

    if Repo.get(Key, key) do
      generate_key() # there is a collision, so we try again
    else
      Repo.insert!(%Key{key: key})
      key
    end
  end

  defp generate_seven_character_key do
    # from the 62 characters, randomly generate strings of length 7.

    :rand.uniform(@count) + @minimum
    |> Integer.digits(62)
    |> Enum.map(&(String.at(@characters, &1)))
    |> Enum.join
  end
end
