defmodule SSIM.Parser do
  @moduledoc """

  # Parser for SSIM

  """

  require Logger

  alias SSIM.{
    HeaderRecord,
    CarrierRecord,
    FlightLegRecord,
    SegmentDataRecord,
    TrailerRecord
  }

  @output_directory "output/"
  @chunk_size 5000
  @record_size 201

  def run(file_path) do
    output_file_name = "#{@output_directory}ssim_records_#{:os.system_time(:millisecond)}.json"
    {:ok, output_file} = File.open(output_file_name, [:write, :append])

    # Write the opening bracket of the JSON array
    IO.write(output_file, "[")

    file_path
    |> File.stream!(@record_size)
    # Process 5000 records at a time
    |> Stream.chunk_every(@chunk_size)
    |> Task.async_stream(&process_chunk(&1, output_file),
      max_concurrency: System.schedulers_online(),
      timeout: :infinity
    )
    |> Stream.run()

    # Write the closing bracket of the JSON array
    IO.write(output_file, "]")

    # Close the file
    File.close(output_file)
  end

  defp process_chunk(chunk, output_file) do
    Enum.with_index(chunk)
    |> Enum.each(fn {row, index} ->
      trimmed_row = String.trim(row)

      case parse_record(trimmed_row) do
        # Skip nil records
        nil ->
          :ok

        data ->
          Logger.info("Processing record no: #{index}")
          json_data = Jason.encode!(data)

          # Write data with comma for every element except the first
          if index == 0 do
            IO.write(output_file, json_data)
          else
            IO.write(output_file, "," <> json_data)
          end
      end
    end)
  end

  defp parse_record(<<"1", _rest::binary>> = row) do
    HeaderRecord.parse(row)
  end

  defp parse_record(<<"2", _rest::binary>> = row) do
    CarrierRecord.parse(row)
  end

  defp parse_record(<<"3", _rest::binary>> = row) do
    FlightLegRecord.parse(row)
  end

  defp parse_record(<<"4", _rest::binary>> = row) do
    SegmentDataRecord.parse(row)
  end

  defp parse_record(<<"5", _rest::binary>> = row) do
    TrailerRecord.parse(row)
  end

  defp parse_record(_), do: nil
end
