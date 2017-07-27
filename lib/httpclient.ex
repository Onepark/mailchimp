defmodule Mailchimp.HTTPClient do
  def get(url, header, timeout) do
    case HTTPoison.get(url, header, timeouts(timeout)) do
      {:ok, %HTTPoison.Response{status_code: 200, body: body}} ->
        process_response_body body
      {:ok, %HTTPoison.Response{status_code: 404}} ->
        "Not found :("
      {:error, %HTTPoison.Error{reason: reason}} ->
        reason
    end
  end

  def post(url, body, header, timeout) do
    case HTTPoison.post(url, body, header, timeouts(timeout)) do
      {:ok, %HTTPoison.Response{status_code: 200, body: body}} ->
        process_response_body body
      {:ok, %HTTPoison.Response{status_code: 400, body: body}} ->
        process_response_body body
      {:ok, %HTTPoison.Response{status_code: 404}} ->
        "Not found :("
      {:error, %HTTPoison.Error{reason: reason}} ->
        reason
    end
  end

  def patch(url, body, header, timeout) do
    case HTTPoison.patch(url, body, header, timeouts(timeout)) do
      {:ok, %HTTPoison.Response{status_code: 200, body: body}} ->
        process_response_body body
      {:ok, %HTTPoison.Response{status_code: 400, body: body}} ->
        process_response_body body
      {:ok, %HTTPoison.Response{status_code: 404}} ->
        "Not found :("
      {:error, %HTTPoison.Error{reason: reason}} ->
        reason
    end
  end

  def delete(url, header, timeout) do
    case HTTPoison.delete(url, header, timeouts(timeout)) do
      {:ok, %HTTPoison.Response{status_code: 200, body: body}} ->
        process_response_body body
      {:ok, %HTTPoison.Response{status_code: 204, body: body}} ->
        :ok
      {:ok, %HTTPoison.Response{status_code: 404}} ->
        "Not found :("
      {:error, %HTTPoison.Error{reason: reason}} ->
        reason
    end
  end

  def process_response_body(body) do
    body
    |> Poison.decode!
    |> Enum.map(fn({k, v}) -> {String.to_atom(k), v} end)
  end

  defp timeouts(t) do
    [connect_timeout: t, recv_timeout: t, timeout: t]
  end
end
