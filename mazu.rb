require 'ruby_spark'
require 'cuba'
require 'json'
require 'tzinfo'

Dir['./models/*.rb'].each  { |f| require f }
Dir['./workers/*.rb'].each { |f| require f }

Shoden.setup
MeasureRainJob.new.async.perform

Cuba.define do
  on root do
    rain = Rain.last

    out = if !rain.nil?
      tz = TZInfo::Timezone.get('America/Montevideo')
      time = Time.at(rain.created_at.to_i)

      {
        timestamp: rain.created_at,
        datetime: tz.utc_to_local(time),
        mm: rain.mm
      }
    else
      {}
    end

   res['Content-Type'] = 'application/json'
   res.write JSON.dump(out)
  end
end
