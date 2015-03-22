use Mix.Config

config :ex_aws,
  access_key_id: "",
  secret_access_key: "",
  ddb_namespace: "staging",
  kinesis_namespace: "staging",
  debug_requests: true,
  ddb_scheme: "http://",
  ddb_host: "localhost",
  ddb_port: 8000
