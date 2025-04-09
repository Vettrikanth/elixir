defmodule SumOfDigits do

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


end
