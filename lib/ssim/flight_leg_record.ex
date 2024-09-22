defmodule SSIM.FlightLegRecord do
  @moduledoc """

  Flight Leg Record - Record Type 3

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
    :operation_from,
    :operation_to,
    :days_of_operation,
    :frequency_rate,
    :departure_station,
    :passenger_std,
    :aircraft_std,
    :departure_time_variation,
    :departure_terminal,
    :arrival_station,
    :aircraft_sta,
    :passenger_sta,
    :arrival_time_variation,
    :arrival_terminal,
    :aircraft_type,
    :prbd,
    :prbm,
    :meal_service_note,
    :joint_op_airline_designator,
    :min_connection_time,
    :secure_flight_indicator,
    :spare,
    :itinerary_variation_overflow,
    :aircraft_owner,
    :cockpit_crew_employer,
    :cabin_crew_employer,
    :onward_airline_designator,
    :onward_flight_number,
    :aircraft_rotation_layover,
    :operational_suffix2,
    :spare2,
    :flight_transit_layover,
    :operating_airline_disclosure,
    :traffic_restriction_code,
    :traffic_restriction_code_indicator,
    :spare3,
    :aircraft_configuration,
    :date_variation,
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
         "3"::binary,
         operational_suffix::binary-size(1),
         airline_designator::binary-size(3),
         flight_number::binary-size(4),
         itinerary_variation_identifier::binary-size(2),
         leg_sequence_number::binary-size(2),
         service_type::binary-size(1),
         operation_from::binary-size(7),
         operation_to::binary-size(7),
         days_of_operation::binary-size(7),
         frequency_rate::binary-size(1),
         departure_station::binary-size(3),
         passenger_std::binary-size(4),
         aircraft_std::binary-size(4),
         departure_time_variation::binary-size(5),
         departure_terminal::binary-size(2),
         arrival_station::binary-size(3),
         aircraft_sta::binary-size(4),
         passenger_sta::binary-size(4),
         arrival_time_variation::binary-size(5),
         arrival_terminal::binary-size(2),
         aircraft_type::binary-size(3),
         prbd::binary-size(20),
         prbm::binary-size(5),
         meal_service_note::binary-size(10),
         joint_op_airline_designator::binary-size(9),
         min_connection_time::binary-size(2),
         secure_flight_indicator::binary-size(1),
         spare::binary-size(5),
         itinerary_variation_overflow::binary-size(1),
         aircraft_owner::binary-size(3),
         cockpit_crew_employer::binary-size(3),
         cabin_crew_employer::binary-size(3),
         onward_airline_designator::binary-size(3),
         onward_flight_number::binary-size(4),
         aircraft_rotation_layover::binary-size(1),
         operational_suffix2::binary-size(1),
         spare2::binary-size(1),
         flight_transit_layover::binary-size(1),
         operating_airline_disclosure::binary-size(1),
         traffic_restriction_code::binary-size(11),
         traffic_restriction_code_indicator::binary-size(1),
         spare3::binary-size(11),
         aircraft_configuration::binary-size(20),
         date_variation::binary-size(2),
         record_serial_number::binary-size(6)
       >>) do
    data =
      [
        record_type: "3",
        operational_suffix: operational_suffix,
        airline_designator: airline_designator,
        flight_number: flight_number,
        itinerary_variation_identifier: itinerary_variation_identifier,
        leg_sequence_number: leg_sequence_number,
        service_type: service_type,
        operation_from: operation_from,
        operation_to: operation_to,
        days_of_operation: days_of_operation,
        frequency_rate: frequency_rate,
        departure_station: departure_station,
        passenger_std: passenger_std,
        aircraft_std: aircraft_std,
        departure_time_variation: departure_time_variation,
        departure_terminal: departure_terminal,
        arrival_station: arrival_station,
        aircraft_sta: aircraft_sta,
        passenger_sta: passenger_sta,
        arrival_time_variation: arrival_time_variation,
        arrival_terminal: arrival_terminal,
        aircraft_type: aircraft_type,
        prbd: prbd,
        prbm: prbm,
        meal_service_note: meal_service_note,
        joint_op_airline_designator: joint_op_airline_designator,
        min_connection_time: min_connection_time,
        secure_flight_indicator: secure_flight_indicator,
        spare: spare,
        itinerary_variation_overflow: itinerary_variation_overflow,
        aircraft_owner: aircraft_owner,
        cockpit_crew_employer: cockpit_crew_employer,
        cabin_crew_employer: cabin_crew_employer,
        onward_airline_designator: onward_airline_designator,
        onward_flight_number: onward_flight_number,
        aircraft_rotation_layover: aircraft_rotation_layover,
        operational_suffix2: operational_suffix2,
        spare2: spare2,
        flight_transit_layover: flight_transit_layover,
        operating_airline_disclosure: operating_airline_disclosure,
        traffic_restriction_code: traffic_restriction_code,
        traffic_restriction_code_indicator: traffic_restriction_code_indicator,
        spare3: spare3,
        aircraft_configuration: aircraft_configuration,
        date_variation: date_variation,
        record_serial_number: record_serial_number
      ]

    struct(__MODULE__, Map.new(data, fn {key, value} -> {key, String.trim(value)} end))
  end
end
