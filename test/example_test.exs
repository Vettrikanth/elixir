defmodule ExampleTest do
  use ExUnit.Case
  doctest Example

  test "Length of Deck" do
    len=length(Example.create_deck)
    assert len ==24
  end

  test "Shuffle Deck" do
    deck= Example.create_deck
    assert deck != Example.shuffle(deck)
  end

end
