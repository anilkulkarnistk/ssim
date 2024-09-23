defmodule SSIM.Tokenizer.HeaderRecord do
  @moduledoc """

  # Header Record - Record Type 1

  """
  require Logger

  @derive Jason.Encoder
  defstruct [
    :record_type,
    :title_of_contents,
    :spare,
    :number_of_seasons,
    :spare2,
    :data_serial_number,
    :record_serial_number
  ]

  def parse(row) do
    if String.length(row) == 200 do
      parse_record(row)
    else
      Logger.error("Improper Record: #{row}")
    end
  end

  defp parse_record(<<
         "1"::binary,
         title_of_contents::binary-size(34),
         spare::binary-size(5),
         number_of_seasons::binary-size(1),
         spare2::binary-size(150),
         data_serial_number::binary-size(3),
         "000001"::binary
       >>) do
    data =
      [
        record_type: "1",
        title_of_contents: title_of_contents,
        spare: spare,
        number_of_seasons: number_of_seasons,
        spare2: spare2,
        data_serial_number: data_serial_number,
        record_serial_number: "000001"
      ]

    struct(__MODULE__, Map.new(data, fn {key, value} -> {key, String.trim(value)} end))
  end
end
