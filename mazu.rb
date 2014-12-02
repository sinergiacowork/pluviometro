require 'ruby_spark'
require 'cuba'
require 'json'
require 'tzinfo'

Dir['./models/*.rb'].each  { |f| require f }
Dir['./workers/*.rb'].each { |f| require f }

Shoden.setup
MeasureRainJob.new.async.perform

Cuba.define do
  def write_json(out)
   res['Content-Type'] = 'application/json'

   res.write JSON.dump(out)
  end

  def rain_output(rain)
    tz = TZInfo::Timezone.get('America/Montevideo')
    time = Time.at(rain.created_at.to_i)

    {
      timestamp: rain.created_at,
      datetime: tz.utc_to_local(time),
      mm: rain.mm
    }
  end

  on "all" do
    drops = []
    Rain.all.each { |rain| drops << rain_output(rain) }

    write_json(drops)
  end

  on root do
    rain = Rain.last
    out = !rain.nil? ? rain_output(rain) : {}

    write_json(out)
  end
end
