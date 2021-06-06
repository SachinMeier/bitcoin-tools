defmodule BitcoinWeb.LayoutView do
  use BitcoinWeb, :view

  # def meta_tags(attrs_list) do
  #   Enum.map(attrs_list, &meta_tag/1)
  # end

  # def meta_tag(attrs) do
  #   tag(:meta, Enum.into(attrs, []))
  # end

  # @all_og_tags ~w"title description image url type"

  # def og_tags(attrs_list) do
  #   Enum.map(attrs_list, &og_tag/1)
  # end

  # def og_tag(attrs) do
  #   if attrs.name in @all_og_tags do
  #     tag(:meta, [property: "og:" <> attrs.name, content: attrs.content])
  #   end
  # end


  defmodule BitcoinWeb.LayoutView.Metatags do

    # META TITLE
    @suffix "Bitcoin Tools"

    def page_title(conn), do: conn.assigns |> get_title |> put_suffix 

    defp put_suffix(nil), do: @suffix
    defp put_suffix(title), do: title <> " | " <> @suffix

    defp get_title(%{option: option}), do: option.title
    defp get_title(%{view_module: StatsView}), do: "Statistics"
    defp get_title(_), do: nil

    # META DESCRIPTION 
    @description "Use and understand Bitcoin's Cryptography: Handle public and private keys, addresses, and signatures."

    def description(conn), do: conn.assigns |> get_description

    defp get_description(%{option: option}), do: option.description
    defp get_description(%{view_module: StatsView}), do: "Bitcoin market and network statistics, including price, hash rate, and more."
    defp get_description(_), do: @description

  end

end
