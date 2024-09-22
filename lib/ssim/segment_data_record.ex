defmodule SSIM.SegmentDataRecord do
  @moduledoc """

  # Segment Data Record - Record Type 4

  """

  require Logger

  @derive Jason.Encoder
  defstruct [
    :record_type,
    :operational_suffix,
    :airline_designator,
    :flight_number,
    :itinerary_variation_identifier,
    :leg_sequence_number,
    :service_type,
    :spare,
    :itinerary_variation_identifier_overflow,
    :board_point_indicator,
    :off_point_indicator,
    :data_element_identifier,
    :board_point,
    :off_point,
    :data,
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
         "4"::binary,
         operational_suffix::binary-size(1),
         airline_designator::binary-size(3),
         flight_number::binary-size(4),
         itinerary_variation_identifier::binary-size(2),
         leg_sequence_number::binary-size(2),
         service_type::binary-size(1),
         spare::binary-size(13),
         itinerary_variation_identifier_overflow::binary-size(1),
         board_point_indicator::binary-size(1),
         off_point_indicator::binary-size(1),
         data_element_identifier::binary-size(3),
         board_point::binary-size(3),
         off_point::binary-size(3),
         data::binary-size(155),
         record_serial_number::binary-size(6)
       >>) do
    data = [
      record_type: "4",
      operational_suffix: operational_suffix,
      airline_designator: airline_designator,
      flight_number: flight_number,
      itinerary_variation_identifier: itinerary_variation_identifier,
      leg_sequence_number: leg_sequence_number,
      service_type: service_type,
      spare: spare,
      itinerary_variation_identifier_overflow: itinerary_variation_identifier_overflow,
      board_point_indicator: board_point_indicator,
      off_point_indicator: off_point_indicator,
      data_element_identifier: data_element_identifier,
      board_point: board_point,
      off_point: off_point,
      data: data,
      record_serial_number: record_serial_number
    ]

    struct(__MODULE__, Map.new(data, fn {key, value} -> {key, String.trim(value)} end))
  end
end
