require 'ruby_spark'
require 'cuba'

Dir['./models/*.rb'].each  { |f| require f }
Dir['./workers/*.rb'].each { |f| require f }

Shoden.setup

SuckerPunch.logger = Logger.new('sucker_punch.log')
MeasureRainJob.new.async.perform

Cuba.define do
  on root do
    rain = Rain.last
    res.write rain.mm if !rain.nil?
  end
end
