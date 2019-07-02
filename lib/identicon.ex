defmodule Identicon do
  @moduledoc """
  Documentation for Identicon.
  """

  def main(input) do
    input
    |> hash
    |> pick_color
    |> build_grid
    |> filter_odd_squares
    |> build_pixel_map
    |> draw_image
    |> save_image(input)
  end

  defp hash(input) do
    hex =  :crypto.hash(:md5, input)
        |> :binary.bin_to_list

    %Identicon.Image{hex: hex}
  end

  defp pick_color(image) do
    [r, g, b | _rest] = image.hex
    %Identicon.Image{image | color: {r,g,b}}
  end

  defp build_grid(image) do
    grid = image.hex
           |> Enum.chunk_every(3, 3, :discard)
           |> Enum.map(fn([a,b | _] = row) -> row ++ [b, a] end)
           |> List.flatten
           |> Enum.with_index
    %Identicon.Image{image | grid: grid}
  end

  defp filter_odd_squares(image) do
    grid = image.grid
    |> Enum.filter(fn ({num, _}) -> rem(num,2) == 0 end)

    %Identicon.Image{image | grid: grid}
  end

  defp build_pixel_map(image) do
    pixel_map = Enum.map image.grid, fn ({_, index}) -> index_to_points(index) end

    %Identicon.Image{image | pixel_map: pixel_map}
  end

  defp index_to_points(index) do
    x_top = rem(index, 5) * 50
    y_top = div(index, 5) * 50

    {{x_top, y_top}, {x_top + 50, y_top + 50}}
  end

  defp draw_image(%Identicon.Image{color: color, pixel_map: pixel_map}) do
    image = :egd.create(250, 250)
    fill = :egd.color(color)

    Enum.each pixel_map, fn ({start, stop}) ->
      :egd.filledRectangle(image, start, stop, fill)
    end

    :egd.render(image)
  end

  defp save_image(image, filename) do
    File.write("#{filename}.png", image)
  end
end
