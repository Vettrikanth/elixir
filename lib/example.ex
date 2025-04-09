defmodule Example do
  @moduledoc """
  this is for creating card
  """
  require Integer
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
  @doc """
  It is used to find if the deck contains the given card

  ## Example


        iex>deck= Example.create_deck
        iex>Example.contains?(deck,"One of spade")
        true
  """
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

  def basics do
    a=32
    Integer.is_even(a) |> IO.inspect()
    Integer.digits(a,2) |> IO.inspect()
    Integer.gcd(32,22) |> IO.inspect()
    Integer.mod(5,2) |>IO.inspect(label: "5 by 2 gives")
    Integer.mod(24,3) |> IO.inspect(label: "24 div by 3")
    nil
  end

  def time do
    t=Time.new!(16,30,0,0)
    d=Date.new!(2025,1,6)
    date_time=DateTime.new!(d,t)
    IO.inspect(date_time)
    nil
  end

  def calc_new_yr do
    time=DateTime.new!(Date.new!(2026,1,1),Time.new!(0,0,0,0),"Etc/UTC")
    time_till=DateTime.diff(time,DateTime.utc_now())
    IO.puts(time_till)

    days=div(time_till,86400)
    IO.inspect(days,label: "days")

    hours=div(rem(time_till,86400),3600)
    IO.inspect(hours,label: "hours")

    mins=div(rem(time_till,3600),60)
    IO.inspect(mins,label: "mins")

    sec=rem(time_till,60)
    IO.inspect(sec,label: "seconds")

  end
  def tuple do

    user1= {"a", :gold}
    user2={"b", :silver}
    user3={"c",:diamond}

    {name,membership} = user1
    IO.puts("#{name} has a #{membership} membership")
    {name,membership} = user2
    IO.puts("#{name} has a #{membership} membership")
    {name,membership} = user3
    IO.puts("#{name} has a #{membership} membership")
  end

  def for_loop do

    users=[
      {"a",:Gold},
      {"b",:Silver},
      {"c",:Diamond},
      {"D",:Gold}
    ]

    Enum.each(users,  fn{n,m} -> IO.puts("#{n} has a #{m} membership") end)

  end

  def input_user do
    ip = IO.gets("Enter a number:") |> String.trim()|>String.to_integer()
    IO.puts( "The entered number #{ip}")

    if Integer.is_even(ip) do
        IO.puts("even")
    else
        IO.puts("Odd")
      end
    # r= :rand.uniform(10)    #Generates from 1 to 10
    # r= :rand.uniform(11)-1  #Generates from 0 to 10
    # IO.puts(r)
    end

    def grades do
      grades=[10,20,30]
      for n <- grades, do: IO.puts(n)
      _new= for  m<- grades , do: m * 10
      grades = grades ++ [40,50] #adding at end
      grades=[ 5 , 6 | grades] #adding at start
      IO.inspect(grades)
    end

    def numbers do
      numbers=[1,2,3,4,5]
      Enum.each(numbers,fn num->IO.puts(num) end)
      numbers2=["6","7","8"]
      r2=Enum.map(numbers2, &String.to_integer/1)
      IO.inspect(r2)
      IO.inspect(sum_and_average(r2))
    end


    def sum_and_average(numbers) do
      sum = Enum.sum(numbers)
      avg = sum/Enum.count(numbers)
      {sum,avg}
    end
    def pin_operator do

      x = 10
      case 10 do
        ^x -> "Matched :ok!"    # only matches if it's exactly :ok
        _ -> "Doesn't match"
      end

    end
    def learn_list do

      l1=[11,12,13]
      IO.puts(Enum.at(l1,0)) #travesing list
      IO.puts(Enum.at(l1,4, :"not found"))

      IO.puts("")
      for i<-l1, do:
      IO.puts(i)
      IO.puts("")

      values = ["One","Two","Three","Four","Five","Six"]
      suits= ["spade","club","heart","diamond"]

      cards = for value <- values, suit<-suits do
        "#{value} of #{suit}"
      end
      IO.inspect(cards)
      IO.puts("")

      IO.inspect(hd(values),label: "Head(1st ele) of Values")
      IO.inspect(hd(l1),label: "Head(1st ele) of List1")

      IO.inspect(tl(values),label: "Tail of Values")
      IO.inspect(tl(l1),label: "Tail of List1", charlists: :as_lists) #this will be parsed a ASCII so used charlists to convert


      word=[99,97,116]
      IO.inspect(word)
      IO.inspect(word, charlists: :as_lists)#this will be parsed a ASCII so used charlists to convert


      :ok  end


      def learn_tuple do

        t1={1,2,"a",:hii}
        IO.inspect(t1)
        {num1,num2,alphabet,atom}=t1
        IO.inspect(num1)
        IO.inspect(num2)
        IO.inspect(alphabet)
        IO.inspect(atom)
        {a,b} = {1,2}
        IO.inspect(a)
        IO.inspect(b)

        #Keyword list

        data=[a: 1, b: 2]
        IO.inspect(is_list(data),label: "Data type")
        IO.inspect(data[:b])
        IO.inspect([{:a, 1}] = [a: 1]) #key word matching

      :ok end

      def learn_map do
        my_map = %{a: 1, b: 2 , c: 3 , d: 10}
        IO.inspect(my_map)
        my_map = %{my_map | d: 15}
        IO.inspect(my_map)
        IO.inspect(my_map.c)
        %{b: second_element} = my_map
        IO.inspect(second_element)
      :ok end


end
