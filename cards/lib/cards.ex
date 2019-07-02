defmodule Cards do
  @moduledoc """
    Methods for creating and handling playing cards
  """

  def create_deck do
    values = ["A", "2", "3", "4", "5", "6", "7", "8", "9", "10", "J", "Q", "K"]
    suits = ["S", "C", "H", "D"]

    for suit <- suits,
        value <- values do
      {value, suit}
    end
  end

  defdelegate shuffle(deck), to: Enum
  defdelegate contains?(deck, card), to: Enum, as: :member?

  @doc """
    Devides a deck into a hand and a remainder deck.
    The `num` is the size of the hand

  ## Examples

      iex> deck = Cards.create_deck
      iex> {hand, remainder_deck} = Cards.deal(deck, 1)
      iex> hand
      [{"A", "S"}]

  """
  def deal(deck, num) do
    Enum.split(deck, num)
  end

  def save(deck, filename) do
    binary = :erlang.term_to_binary(deck)
    File.write(filename, binary)
  end

  def load(filename) do
    case File.read(filename) do
      {:ok, binary} -> {:ok, :erlang.binary_to_term(binary)}
      _ -> {:error, "File does not exist"}
    end
  end
end
