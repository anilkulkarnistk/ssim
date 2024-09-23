defmodule SSIM.Parser do
  @moduledoc """
  Optimized parser for SSIM records
  """

  require Logger

  alias SSIM.Tokenizer.{
    HeaderRecord,
    CarrierRecord,
    FlightLegRecord,
    SegmentDataRecord,
    TrailerRecord
  }

  @output_directory "output/"

  # Read file in 16KB chunks
  @file_chunk_size 16 * 1024

  # SSIM records are 201 bytes
  @record_size 201

  # Buffer size for write operations
  @buffer_size 5000

  def run(file_path) do
    # Start the timer
    start_time = System.monotonic_time(:millisecond)

    # Create output file
    :ok = File.mkdir_p(@output_directory)
    output_file_name = "#{@output_directory}ssim_records_#{:os.system_time(:millisecond)}.json"
    {:ok, output_file} = File.open(output_file_name, [:write, :append])

    # Write the opening bracket of the JSON array
    IO.write(output_file, "[")

    total_records =
      file_path
      # Stream in 16KB chunks
      |> File.stream!(@file_chunk_size)
      # Ensure 201-byte record alignment
      |> Stream.transform("", &split_and_reassemble/2)
      # Process 5000 records at a time
      |> Stream.chunk_every(@buffer_size)
      # Process chunks concurrently
      |> Task.async_stream(&process_chunk(&1, output_file),
        max_concurrency: System.schedulers_online() * 2,
        timeout: :infinity
      )
      # Fetch the total number of records
      |> Enum.reduce(0, fn {:ok, num}, acc -> num + acc end)

    # Write the closing bracket of the JSON array
    IO.write(output_file, "]")

    # Close the file
    File.close(output_file)

    # End the timer
    end_time = System.monotonic_time(:millisecond)
    total_time = end_time - start_time

    IO.puts("Total Records Parsed: #{total_records}")
    IO.puts("Total Elapsed Time: #{total_time}ms or #{Float.round(total_time / 1000)}sec")
    IO.puts("Processing Rate: #{round(total_records / total_time * 1000)}/sec")
  end

  # Splits a chunk of binary data into exact 201-byte records and reassembles leftover partial records
  defp split_and_reassemble(data, leftover) do
    # Combine leftover data with new chunk
    data = leftover <> data
    full_records_size = div(byte_size(data), @record_size) * @record_size
    <<records::binary-size(full_records_size), remaining::binary>> = data

    records = for <<record::binary-size(@record_size) <- records>>, do: record
    {records, remaining}
  end

  # Process a chunk of 5000 records
  defp process_chunk(records, output_file) do
    num_records = length(records)

    Logger.info("Processing #{num_records} records...")

    json_chunk =
      records
      # Remove "\n" from each record, new chunk size is 200 bytes.
      |> Stream.map(&String.trim/1)
      # Parse each 200 byte record
      |> Stream.map(&parse_record/1)
      # Filter out nil records
      |> Stream.filter(&(&1 != nil))
      # Convert to JSON and join with commas
      |> Enum.map_join(",", &Jason.encode!(&1))

    # Write the chunk of JSON records at once
    IO.write(output_file, json_chunk)

    num_records
  end

  # Parsing based on SSIM record types
  defp parse_record(<<"1", _rest::binary>> = row), do: HeaderRecord.parse(row)
  defp parse_record(<<"2", _rest::binary>> = row), do: CarrierRecord.parse(row)
  defp parse_record(<<"3", _rest::binary>> = row), do: FlightLegRecord.parse(row)
  defp parse_record(<<"4", _rest::binary>> = row), do: SegmentDataRecord.parse(row)
  defp parse_record(<<"5", _rest::binary>> = row), do: TrailerRecord.parse(row)
  # Skip unknown records
  defp parse_record(_), do: nil
end
