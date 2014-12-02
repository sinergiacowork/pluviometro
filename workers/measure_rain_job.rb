require 'sucker_punch'

class MeasureRainJob
  include SuckerPunch::Job

  THRESHOLD = 5 * 60

  def perform
    last_tip = 0

    loop do
      space = RubySpark::Core.new(ENV['DEVICE_UUID'], ENV['API_SECRET'])
      tip = space.variable("rain").to_i

      if !last_tip.zero?
        mm = ((tip - last_tip)/2)*0.3
        Rain.create(mm: mm) if mm > 0
      end

      last_tip = tip

      sleep THRESHOLD
    end
  end
end
