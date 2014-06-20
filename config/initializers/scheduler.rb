require 'rufus-scheduler'

s = Rufus::Scheduler.singleton
s.cron '00 00 * * 0' do
  CollectFood.perform
end
