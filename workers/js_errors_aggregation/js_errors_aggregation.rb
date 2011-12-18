require 'rubygems'
require 'a15-worker'
require 'json'
require 'mysql2'

class SimpleWorker
  include A15::Worker
  
  def initialize(config)
    @config = config
  end

  def calc_time_slot(d)
    date = Time.at(d)
    minute = 10 * (date.min / 10)
    Time.new(date.year,date.month, date.day, date.hour, minute).strftime("%Y-%m-%d %H:%M")
  end
  
  def write_to_db (errors_by_time)
    errors_by_time.each { |time_slot, count|
        query = %Q{insert into #{@aggregration_table} (time, count) values ('#{time_slot}', #{count})  
                on duplicate key update count = count + #{count}
        }
        p query 
        @dbh.query(query)
    }
    @dbh.query("commit")
  end
  
  def run
    options = {
      :host              => @config[:host],
      :queue_name        => @config[:queue_name],
      :logger_key_prefix => "a15.logger.#{@config[:worker_name]}",
      :sqluser 		       => @config[:sqluser],
      :sqlpass		       => @config[:sqlpass],
      :sqlhost           => @config[:sqlhost],
      :sqldb             => @config[:sqldb],
      :sqltable          => @config[:sqltable]
    }
    @dbh = Mysql2::Client.new(
                              :host => options[:sqlhost],
                              :username =>options[:sqluser],
                              :password =>options[:sqlpass],
                              :database => options[:sqldb]
                              )

    @aggregration_table = options[:sqltable]

    counter = 0

    errors_by_time = {}

    work(options) do |messages|
      messages.each { |msg|

          continue if msg["errorType"] != "JSError"
          counter +=1
          date = msg["timestamp"].to_i
          time_slot = calc_time_slot(date);
          errors_by_time[time_slot] = 0 if !errors_by_time.has_key?(time_slot);
          errors_by_time[time_slot] += 1
          if(counter> 1000)
              begin 
                  write_to_db (errors_by_time) 
                  errors_by_time = {}
                  counter = 0
              rescue  Exception => e
                    p e
              end
          end
      }
    end	
  end
end

SimpleWorker.new({
  :host        => '127.0.0.1',
  :queue_name  => 'errors_for_aggregation',
  :worker_name => 'js_errors',
  :sqluser 		 => 'sa',
  :sqlpass		 => 'sakontera',
  :sqlhost     => 'int16',
  :sqldb       => 'mercury_reporting',
  :sqltable    => 'js_errors'
}).run
