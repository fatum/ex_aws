defmodule ExAws.Config do
  require Record
  @attrs Record.extract(:aws_config, from_lib: "erlcloud/include/erlcloud_aws.hrl")
  Record.defrecord :aws_config, @attrs

  def erlcloud_config do
    conf = Application.get_all_env(:ex_aws)
      |> Enum.map(fn
        {k,v} when is_binary(v) -> {k, String.to_char_list(v)}
        x -> x
      end)

    :erlcloud_aws.default_config
      |> aws_config(ddb_scheme: conf[:ddb_scheme])
      |> aws_config(ddb_host: conf[:ddb_host])
      |> aws_config(ddb_port: conf[:ddb_port])
      |> aws_config(access_key_id: conf[:access_key_id])
      |> aws_config(secret_access_key: conf[:secret_access_key])
  end


  def config_map(config) do
    @attrs |> Enum.with_index |> Enum.reduce(%{}, fn({{attr, _}, i}, map) ->
      Map.put(map, attr, elem(config, i + 1))
    end)
  end

  ## Dynamo
  #####################

  def namespace(%{TableName: table} = data, :dynamo) do
    Map.put(data, :TableName, namespace(table, :dynamo))
  end
  def namespace(data = %{}, :dynamo), do: data

  def namespace(name, :dynamo) when is_atom(name) or is_binary(name) do
    [name, Application.get_env(:ex_aws, :ddb_namespace)]
      |> Enum.filter(&(&1))
      |> Enum.join("-")
  end

  ## Kinesis
  #####################

  def namespace(%{StreamName: stream} = data, :kinesis) do
    Map.put(data, :StreamName, namespace(stream, :kinesis))
  end
  def namespace(data = %{}, :kinesis), do: data

  def namespace(name, :kinesis) when is_atom(name) or is_binary(name) do
    [name, Application.get_env(:ex_aws, :kinesis_namespace)]
      |> Enum.filter(&(&1))
      |> Enum.join("-")
  end

end
