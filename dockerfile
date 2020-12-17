FROM bitwalker/alpine-elixir-phoenix:latest
WORKDIR /app
EXPOSE 4000
CMD mix phx.server
