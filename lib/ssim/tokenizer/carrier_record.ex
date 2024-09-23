defmodule SSIM.Tokenizer.CarrierRecord do
  @moduledoc """

  # Carrier Record - Record Type 2

  """

  require Logger

  @derive Jason.Encoder
  defstruct [
    :record_type,
    :time_mode,
    :airline_designator,
    :spare,
    :season,
    :spare2,
    :schedule_validity_from,
    :schedule_validity_to,
    :creation_date,
    :title_of_data,
    :release_date,
    :schedule_status,
    :creator_ref,
    :duplicate_airline_marker,
    :general_info,
    :inflight_service_info,
    :etkt_info,
    :creation_time,
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
         "2"::binary,
         time_mode::binary-size(1),
         airline_designator::binary-size(3),
         spare::binary-size(5),
         season::binary-size(3),
         spare2::binary-size(1),
         schedule_validity_from::binary-size(7),
         schedule_validity_to::binary-size(7),
         creation_date::binary-size(7),
         title_of_data::binary-size(29),
         release_date::binary-size(7),
         schedule_status::binary-size(1),
         creator_ref::binary-size(35),
         duplicate_airline_marker::binary-size(1),
         general_info::binary-size(61),
         inflight_service_info::binary-size(19),
         etkt_info::binary-size(2),
         creation_time::binary-size(4),
         record_serial_number::binary-size(6)
       >>) do
    data =
      [
        record_type: "2",
        time_mode: time_mode,
        airline_designator: airline_designator,
        spare: spare,
        season: season,
        spare2: spare2,
        schedule_validity_from: schedule_validity_from,
        schedule_validity_to: schedule_validity_to,
        creation_date: creation_date,
        title_of_data: title_of_data,
        release_date: release_date,
        schedule_status: schedule_status,
        creator_ref: creator_ref,
        duplicate_airline_marker: duplicate_airline_marker,
        general_info: general_info,
        inflight_service_info: inflight_service_info,
        etkt_info: etkt_info,
        creation_time: creation_time,
        record_serial_number: record_serial_number
      ]

    struct(__MODULE__, Map.new(data, fn {key, value} -> {key, String.trim(value)} end))
  end
end
