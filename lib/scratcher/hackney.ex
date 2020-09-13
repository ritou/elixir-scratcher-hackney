defmodule Scratcher.Hackney do
  @moduledoc """
  It is a module for using Hackney in the interface of [Scratcher.HttpClient](https://github.com/ritou/elixir-scratcher/blob/master/lib/scratcher/http_client.ex).
  """

  @behaviour Scratcher.HttpClient

  @default_opts [recv_timeout: 30_000]

  @doc """

  You can specify Hackney options. Check the default value.

  ```elixir
  # default
  config :scratcher_hackney, :hackney_opts, recv_timeout: 30_000
  ```

  As described in [Scratcher.HttpClient](https://github.com/ritou/elixir-scratcher), you can use it equivalently to other HTTP Clients.

  ```elixir
  config :your_module, http_client: Scratcher.Hackney
  ```

  ```elixir
  defmodule YourModule do
    @http_client Application.fetch_env!(:your_module) |> Keyword.fetch!(:http_client)

    def request(method, url, body, headers, http_opts) do
      @http_client.request(method, url, body, headers, http_opts)
    end
  end
  ```

  """
  def request(method, url, body \\ "", headers \\ [], http_opts \\ []) do
    opts = Application.get_env(:scratcher_hackney, :hackney_opts, @default_opts)
    opts = http_opts ++ [:with_body | opts]

    case :hackney.request(method, url, headers, body, opts) do
      {:ok, status, headers} ->
        {:ok, %{status_code: status, headers: headers, body: ""}}

      {:ok, status, headers, body} ->
        {:ok, %{status_code: status, headers: headers, body: body}}

      {:error, reason} ->
        {:error, %{reason: reason}}
    end
  end
end
