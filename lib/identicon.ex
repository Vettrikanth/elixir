defmodule Identicon do
  def main(input)do

    input
    |> hash_input
    |> pick_color
    |> build_grid
    |> filter_even
    |> build_pixel
    |> draw_image
    |> save_image(input)

  end

  def save_image(image,input)do
    File.write("#{input}.png",image)
  end


  def draw_image(%Identicon.Image{color: color , pixelmap: pixelmap}) do
    image = :egd.create(250,250)
    fill = :egd.color(color)

    Enum.each pixelmap , fn({start,stop})-> :egd.filledRectangle(image,start,stop,fill)
    end
    :egd.render(image)
  end

  def build_pixel(%Identicon.Image{grid: grid}=image) do
    pixelmap = Enum.map grid,fn ({ _ , index})->
      horizontal = rem(index,5)*50
      vertical = div(index,5)*50

      top_left={horizontal,vertical}
      bottom_right={horizontal+50,vertical+50}

      {top_left, bottom_right}

    end

    %Identicon.Image{image | pixelmap: pixelmap}
  end

  def filter_even(%Identicon.Image{grid: grid}= image) do
    grid = Enum.filter(
     grid,
     fn {value, _index} -> rem(value,2) == 0
    end
    )
      %Identicon.Image { image | grid: grid}
  end

  def mirror_row(image) do
      [first , second | _] = image
      image ++ [second,first]
  end

  def build_grid(%Identicon.Image{hex: hex}= image)do
    grid= hex
    |> Enum.chunk_every(3 ,3, :discard) #to chunk the list
    |> Enum.map(&mirror_row/1)
    |> List.flatten
    |> Enum.with_index

    %Identicon.Image{image | grid: grid} #after creating grid update it in Struct

  end

  def pick_color(image) do
    %Identicon.Image{hex: [r,g,b | _ ]} = image  #Pattern Matching only first 3 ; can replace this whole in above line also ()
    %Identicon.Image{image | color: {r,g,b}}     #assigning those 3 to the strcut
  end

  def hash_input(input)do
    hex =:crypto.hash(:md5,input)
    |> :binary.bin_to_list

    %Identicon.Image{hex: hex}



  end


end
