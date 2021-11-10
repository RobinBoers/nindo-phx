defmodule NindoPhxWeb.ViewHelpers do
  @moduledoc false

  alias Calendar.DateTime
  alias Calendar.DateTime.{Format, Parse}

  # Template helpers

  def safe(txt), do: {:safe, txt}

  # Date and time

  def now() do
    human_datetime Nindo.Core.datetime()
  end

  def human_datetime(d) do
    "#{d.day}/#{d.month}/#{d.year}"
  end

  def to_rfc822(datetime) do
    datetime
    |> NaiveDateTime.to_erl()
    |> DateTime.from_erl!("Etc/UTC")
    |> Format.rfc2822()
  end

  def from_rfc822(datetime) do
    datetime
    |> Parse.rfc2822_utc()
    |> DateTime.to_naive()
  end

  # User and session managment

  def logged_in?(conn) do
    conn.private.plug_session["logged_in"] == true
  end

  def user(conn) do
    Nindo.Accounts.get conn.private.plug_session["user_id"]
  end
end
