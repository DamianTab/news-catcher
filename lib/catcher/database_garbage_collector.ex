defmodule Catcher.DatabaseGarbageCollector do
  require Logger
  use GenServer

  alias Catcher.Account

  def start_link(_opts) do
    GenServer.start_link(__MODULE__, %{})
  end

  def init(state) do
    Logger.info  "Starting Database Garbage Collector..."
    schedule_work() # Schedule work to be performed at some point
    {:ok, state}
  end

  def handle_info(:work, state) do
    Logger.info  "Database Garbage Collector - cleaning database..."
    Account.clean_users()
    Account.clean_favourites()
    Logger.info  "Database Garbage Collector - database cleaned."
    schedule_work() # Reschedule once more
    {:noreply, state}
  end

  defp schedule_work() do
    Process.send_after(self(), :work, 1 * 2 * 60 * 1000) # h,min,s,ms
  end

end
