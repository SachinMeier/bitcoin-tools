FROM bitwalker/alpine-elixir-phoenix:latest

WORKDIR /app

COPY mix.exs .
COPY mix.lock .

RUN mkdir assets

COPY apps/bitcoin_web/assets/package.json assets
COPY apps/bitcoin_web/assets/package-lock.json assets

CMD mix deps.get && cd apps/bitcoin_web/assets && npm install && cd .. && mix phx.server