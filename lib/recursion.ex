defmodule Recursion do
  def upto(0) do
    :ok
  end

  def upto(nums)do
    IO.puts(nums)
    upto(nums-1)
  end

end

defmodule Recursion.SumOfDigits do

  def upto(0)  do
    0
  end

  def upto(num) do
    num + upto(num-1)
    # IO.puts(sum)
  end
  def wholesum (0) do
    0
  end

  def wholesum(num) when num > 0 do
    rem(num,10) + wholesum(div(num,10))
  end

  def factorial(0) do
    1
  end

  def factorial(1) do
    1
  end

  def factorial(num) do
    num*factorial(num-1)
  end

  def reverse(num,acc \\0)
  def reverse(0,acc), do: acc

  def reverse(num,acc) do
    new_num=div(num,10)
    sum= acc *10 + rem(num,10)
    reverse(new_num,sum)
  end

  #accumalate variable


  def sum(num), do: sum(num,0)

  def sum(0,acc) do
    acc
  end

  def sum(num,acc) do
    sum(num-1,acc+num)
  end

  #accumalte for list sum aka Tail Recursive
  def list_sum(num,acc \\0)       #default value of acc set to 0
  def list_sum([],acc), do: acc   #after iterating list becomes empty so set to return the value
  def list_sum([h | t],acc) do
    list_sum(t,acc+h)
  end

  def reverse_list(list,acc \\[])
  def reverse_list([],acc), do: acc
  def reverse_list([h | t ], acc) do
    reverse_list(t , [h | acc])
  end

  def map(list,func,acc \\[])
  def map([],_,acc), do: acc |> Recursion.SumOfDigits.reverse_list()
  def map([h | t],func,acc) do
    map(t,func, [func.(h) | acc])
  end


end
