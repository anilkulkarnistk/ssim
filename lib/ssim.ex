defmodule SSIM do
  @moduledoc """

  # SSIM

  IATA Standard Schedules Information (Chapter 7)

  ## SSIM consists of 5 different binary record types -

  1. Record Type 1 - Header
  2. Record Type 2 - Carrier
  3. Record Type 3 - Flight Leg
  4. Record Type 4 - Segment Data
  5. Record Type 5 - Trailer

  """

  alias SSIM.Parser

  def parse_ssim(file_path) do
    Parser.run(file_path)
  end
end
