require 'ruby_spark'
require 'cuba'
require 'json'

Dir['./models/*.rb'].each  { |f| require f }
Dir['./workers/*.rb'].each { |f| require f }

Shoden.setup
MeasureRainJob.new.async.perform

Cuba.define do
  on root do
    rain = Rain.last

    out =  if !rain.nil?
      { timestamp: rain.created_at, mm: rain.mm }
    else
      {}
    end

   res['Content-Type'] = 'application/json'
   res.write JSON.dump(out)
  end
end
