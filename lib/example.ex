defmodule Example do
  @moduledoc """
  this is for creating card
  """
  @doc """
  returns a list of playing cards
  """
  def create_deck do
    values = ["One","Two","Three","Four","Five","Six"]
    suits= ["spade","club","heart","diamond"]

    for value <- values, suit<-suits do
      "#{value} of #{suit}"
    end
    end
  @doc """
  it is used to shuffle
  """
  def shuffle(deck) do
    Enum.shuffle(deck)
  end

  def contains?(deck,card) do
    Enum.member?(deck,card)
  end

  @doc """
  This Is Used to split the docs based on Input Given

  ## Examples

        iex> deck=Example.create_deck
        iex> {hand,deck} = Example.deal(deck,1)
        iex>hand
        ["One of spade"]

  """

  def deal(deck,hand_size) do
    Enum.split(deck,hand_size)
  end

  def save(deck,savename) do
    binary=:erlang.term_to_binary(deck)
    File.write(savename,binary)
  end

  def read(filename) do
    {status,binary_deck}=File.read(filename)
    case status do
      :ok -> :erlang.binary_to_term(binary_deck)
      :error -> "No such file"
    end
  end

  def create_hand(hand_size) do
    Example.create_deck
    |> Example.shuffle
    |> Example.deal(hand_size)
  end

end
