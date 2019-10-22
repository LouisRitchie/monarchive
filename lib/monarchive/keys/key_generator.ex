defmodule Monarchive.Keys.KeyGenerator do
  alias Monarchive.Keys.Key
  alias Monarchive.Repo

  def generate_key do
    key = generate_seven_character_key()

    # if Repo.get(Key, key) do
    #   generate_key() # there is a collision, so we try again
    # else
    #   Repo.insert!(%Key{key: key})
    #   key
    # end
  end

  defp generate_seven_character_key do
    # randomly generate strings of length 7 composed of the given terminals
    # there are 62 terminals, thus we are working in base 62

    terminals = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
    max_number = 3_521_614_606_207 # this is [61, 61, 61, 61, 61, 61, 61]
    min_number = 56_800_235_584 # this is [1, 0, 0, 0, 0, 0, 0]
    count = max_number - min_number # the count of all base 62 numbers with exactly 7 digits

    key = :rand.uniform(count) + min_number
          |> Integer.digits(62)
          |> Enum.map(&(String.at(terminals, &1)))
          |> Enum.join

    key
  end
end
