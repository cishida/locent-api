HireFire::Resource.configure do |config|
  config.dyno(:resque) do
    HireFire::Macro::Resque.queue(mapper: :active_record)
  end
end