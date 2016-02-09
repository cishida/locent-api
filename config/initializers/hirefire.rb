HireFire::Resource.configure do |config|
  config.dyno(:worker) do
    HireFire::Macro::Resque.queue(mapper: :active_record)
  end
end