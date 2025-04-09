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

end
