defmodule NindoPhxWeb.ErrorHelpers do
  @moduledoc false

  # This module is only used for validation, which isn't implemented in Nindo yet.
  # Instead I use Nindo.Core.format_error/1

  use Phoenix.HTML

  @doc """
  Generates tag for inlined form input errors.
  """
  def error_tag(form, field) do
    Enum.map(Keyword.get_values(form.errors, field), fn error ->
      content_tag(:span, translate_error(error),
        class: "invalid-feedback",
        phx_feedback_for: input_name(form, field)
      )
    end)
  end

  @doc """
  Translates an error message using gettext.
  """
  def translate_error({msg, opts}) do
    if count = opts[:count] do
      Gettext.dngettext(NindoPhxWeb.Gettext, "errors", msg, msg, count, opts)
    else
      Gettext.dgettext(NindoPhxWeb.Gettext, "errors", msg, opts)
    end
  end
end
