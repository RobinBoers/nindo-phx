defmodule NindoPhxWeb.RSSHelpers do
    @moduledoc false

    def detect_feed(source) do
      "https://" <> source <> "/feeds/posts/default?alt=rss"
    end
end
