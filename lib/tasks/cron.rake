namespace(:cron) do 
  
  desc "Run nightly cron tasks"
  task(:cron => ['reminders:tomorrow']) do
    puts "Cron jobs for today finished!"
  end
  
end

task(:cron => 'cron:daily')
