# SSIM

![SSIM Parser - Anil Kulkarni](./assets/ssim_parser_Anil_Kulkarni.jpeg)

High Performance SSIM Parser for IATA Standard Schedules Information (Chapter 7)

Warning: This is still in alpha and can undergo breaking changes.

## Record Types

SSIM consists of 5 different binary `Record Types` -

  1. Record Type 1 - [Header](./lib/ssim/header_record.ex)
  2. Record Type 2 - [Carrier](./lib/ssim/carrier_record.ex)
  3. Record Type 3 - [Flight Leg](./lib/ssim/flight_leg_record.ex)
  4. Record Type 4 - [Segment Data](./lib/ssim/segment_data_record.ex)
  5. Record Type 5 - [Trailer](./lib/ssim/trailer_record.ex)

## Running Application

1. Make sure [Elixir](https://elixir-lang.org/install.html) is installed.
2. Open terminal and start `iex`.

    ```bash
      iex -S mix
    ```

3. Inside `iex` call the `parse_ssim` function and pass your file path.

    ```bash
      iex(1)> file_path = "./sample/sample.ssim"

      iex(2)> SSIM.parse_ssim(file_path)
    ```

    No specific file `ext` is needed for SSIM file name, for example instead of `sample.ssim` you could have just passed `sample_file` or `sample_file.ssm`, the extension does not matter as the file is read as binary.

4. Parser writes the processed `SSIM` file as `json` file under `output` directory with `timestamp` as the file name, example -

    ```bash
      output/ssim_records_1727035431736.json
    ```

## Optimizations -

The intention was not only to write a `Correct` but also a `High Performance` parser, so the following optimizations have been done -

1. Parser highly leverages `concurrency` primitives to parse data in `parallel`.
2. `I/O` stream is used to open and process the `SSIM` as well as output `json` file.
3. File is streamed in `16KB` chunks to maximise `CPU Cache`.
4. Data is batched in `5000` records to process at one time.
5. Actual record parsing uses highly optimized binary `Pattern Matching` instead of `Regex` or `Slicing`.
6. Write buffer is used to write batches of `5000` records to minimize `disk access`.

## SSIM Reference

1. [Sample SSIM](https://raw.githubusercontent.com/Avionworx/Gna.Iata/refs/heads/master/sample.ssim)
