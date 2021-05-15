defmodule BitcoinWeb.StatsView do
  use BitcoinWeb, :view

  def render_stat(item, unit) when is_atom(unit), do: Money.to_string(Money.new(item, unit))
  def render_stat(data, unit) do
    data
  end

  def get_metrics() do
    case Bitcoin.Stats.get_clark_moody_data() do
      {:error, _} -> {:error, ":("}
      res = %{} -> 
        {:ok, [
        %{title: "Price",
          data_point: res.p,
          unit: :USD
        },
        %{title: "Market Cap",
          data_point: res.c / 100_000_000,
          unit: :USD
        },
        %{title: "Moscow Time",
          data_point: res.sd,
          unit: "sats"
        },
        %{title: "Total Supply",
          data_point: res.s / 1_000_000,
          unit: "Million BTC"
        },
        %{title: "Hash Rate",
          data_point: res.hra,
          unit: "EH/s"
        },
        %{title: "Block Reward",
          data_point: res.r,
          unit: :BTC
        }
      ]}
    end
  end

  def get_test_metrics() do
    {:ok, [
      %{title: "Price",
        data_point: 5_500_000,
        unit: :USD
      },
      %{title: "Market Cap",
        data_point: 100_000,
        unit: "Billion USD"
      },
      %{title: "Moscow Time",
        data_point: 1776,
        unit: "sats"
      },
      %{title: "Total Supply",
        data_point: (1_800_000_000_000_000 / 1_000_000),
        unit: "Million BTC"
      },
      %{title: "Hash Rate",
        data_point: 123.50,
        unit: "EH/s"
      },
      %{title: "Block Reward",
        data_point: 625_000_000,
        unit: "BTC"
      }
    ]}
  end

end

