use Mix.Config

if Mix.env() == :test do
  import_config("test.exs")
end

if Mix.env() == :dev do
  import_config("dev.exs")
end
