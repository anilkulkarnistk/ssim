defmodule SSIM.Tokenizer.TrailerRecord do
  @moduledoc """

  # Trailer Record - Record Type 5

  """

  @derive Jason.Encoder
  defstruct [
    :record_type,
    :spare,
    :airline_designator,
    :release_date,
    :spare2,
    :serial_num_check_ref,
    :cont_or_end_code,
    :record_serial_number
  ]

  def parse(row) do
    if String.length(row) != 200 do
      {:error, {:improper_record, row}}
    else
      parse_record(row)
    end
  end

  defp parse_record(<<
         "5"::binary,
         spare::binary-size(1),
         airline_designator::binary-size(3),
         release_date::binary-size(7),
         spare2::binary-size(175),
         serial_num_check_ref::binary-size(6),
         cont_or_end_code::binary-size(1),
         record_serial_number::binary-size(6)
       >>) do
    data = [
      record_type: "5",
      spare: spare,
      airline_designator: airline_designator,
      release_date: release_date,
      spare2: spare2,
      serial_num_check_ref: serial_num_check_ref,
      cont_or_end_code: cont_or_end_code,
      record_serial_number: record_serial_number
    ]

    struct(__MODULE__, Map.new(data, fn {key, value} -> {key, String.trim(value)} end))
  end
end
