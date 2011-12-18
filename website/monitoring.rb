require 'rubygems'
require 'sinatra'
require 'sinatra/reloader'
require 'mysql2'


def convert (time)
 # "#{time.hour}:#{time.min}"
  time.strftime('%R')
end

def calcSlot(time)
  (time.hour * 60 + time.min) / 10
end

def get_day_str (num_days_before)
  now = Time.now
  t = now-(num_days_before*24*60*60)
  Time.local(t.year,t.month,t.day).strftime("%Y-%m-%d")
end

def get_daily_data (num_days_before)
  client = Mysql2::Client.new(:host => "int16", :username => "sa", :password =>"sakontera", :database => "mercury_reporting")

  day_start = get_day_str (num_days_before)
  day_end = get_day_str (num_days_before-1)

  query = "select * from js_errors where time >= '#{day_start}' and time < '#{day_end}'"
  results = client.query(query)

  data = [0]*144
  results.each do |timeslot|
    i = calcSlot(timeslot["time"])
    data[i] = timeslot["count"]
  end

  client.close

  return  data
end

def get_total_errors (daily)
  counter = 0
  daily.each do |dailyErrors|
    counter+=dailyErrors
  end
  counter
end

def get_categories
  arr = []
  24.times {|h|
    6.times {|m|
      min = (10*m).to_s
      min = '0' + min if min == '0'
      arr << "#{h}:#{min}"
    }
  }
  return arr
end


get '/' do
  @title = 'Index Page'
  erb :index
end

get '/js_errors' do
  @data = []
  @days = []
  @totalErrors = []
  @title = 'Javascript Errors'
  @categories  =  get_categories
  dataSeries = [3,4,10]

  dataSeries.each_with_index do |day, index|
    @data[index] = get_daily_data(day)
    @days[index] = get_day_str(day)
    @totalErrors[index] = get_total_errors(@data[index])
    p @totalErrors[index]
  end

  erb :js_errors
end

get '/about' do
  @title = 'About Awesome Site'
  erb :about
end

