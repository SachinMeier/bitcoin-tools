defmodule BitcoinWeb.LayoutView do
  use BitcoinWeb, :view

  def meta_tags(attrs_list) do
    Enum.map(attrs_list, &meta_tag/1)
  end

  def meta_tag(attrs) do
    tag(:meta, Enum.into(attrs, []))
  end

  @all_og_tags ~w"title description image url type"

  def og_tags(attrs_list) do
    Enum.map(attrs_list, &og_tag/1)
  end

  def og_tag(attrs) do
    if attrs.name in @all_og_tags do
      tag(:meta, [property: "og:" <> attrs.name, content: attrs.content])
    end
  end

end
