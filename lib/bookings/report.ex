defmodule Flightex.Bookings.Report do
  alias Flightex.Bookings.Agent, as: BookingAgent

  def generate(filename \\ "report.csv") do
    booking_list = build_booking_list()

    File.write(filename, booking_list)
  end

  defp build_booking_list() do
    BookingAgent.list_all()
    |> Map.values()
    |> Enum.map(fn booking -> booking_to_string(booking) end)
  end

  defp booking_to_string(%{
         user_id: user_id,
         local_origin: local_origin,
         local_destination: local_destination,
         complete_date: complete_date
       }) do
    "#{user_id},#{local_origin},#{local_destination},#{NaiveDateTime.to_string(complete_date)}\n"
  end
end
