defmodule CardsTest do
  use ExUnit.Case
  doctest Cards

  test "create deck creates a full deck of playing cards" do
    deck = Cards.create_deck
    assert length(deck) == 52
  end

  test "shuffle returns a new and shuffled deck" do
    deck = Cards.create_deck
    shuffled_deck = Cards.shuffle(deck)

    assert deck != shuffled_deck
  end
end
