defmodule Flightex.Bookings.Report do
  alias Flightex.Bookings.Agent, as: BookingAgent

  def generate(filename \\ "report.csv") do
    booking_list = build_booking_list()

    File.write(filename, booking_list)
  end

  def generate_report(from_date, to_date) do
    booking_list = build_booking_list(from_date, to_date)

    File.write("report.csv", booking_list)
  end

  defp build_booking_list() do
    BookingAgent.list_all()
    |> Map.values()
    |> Enum.map(fn booking -> booking_to_string(booking) end)
  end

  defp build_booking_list(from_date, to_date) do
    BookingAgent.list_all()
    |> Map.values()
    |> Enum.filter(fn %{complete_date: complete_date} ->
      is_between_dates(complete_date, from_date, to_date)
    end)
    |> Enum.map(fn booking -> booking_to_string(booking) end)
  end

  defp is_between_dates(date, from_date, to_date) do
    {:ok, from_date_naive} = NaiveDateTime.from_iso8601(from_date)
    {:ok, to_date_naive} = NaiveDateTime.from_iso8601(to_date)

    from_date_comparison = NaiveDateTime.compare(date, from_date_naive)
    to_date_comparison = NaiveDateTime.compare(date, to_date_naive)

    (from_date_comparison == :gt or from_date_comparison == :eq) and
      (to_date_comparison == :lt or to_date_comparison == :eq)
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
