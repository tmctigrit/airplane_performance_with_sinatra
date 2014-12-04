require 'pg'
require 'sinatra'

set :bind, '0.0.0.0'

get '/' do
  db = PG.connect(host: 'localhost', dbname: 'airline_data')
  #get num of different airlines
  sql = 'SELECT COUNT(DISTINCT carrier) FROM airline_performance'
  @result = db.exec(sql)
  @result_entries = @result.entries

  #airline with most delayed flights
  pql = 'SELECT carrier, COUNT(*) FROM airline_performance WHERE arr_delay_new > 0 GROUP BY carrier ORDER BY count desc'
  @delayed = db.exec(pql)
  @delayed_entries = @delayed.entries.first

  #airline with fewest delayed flights
  gql = 'SELECT carrier, COUNT(*) FROM airline_performance WHERE arr_delay_new > 0 GROUP BY carrier ORDER BY count asc'
  @fewest_delayed = db.exec(gql)
  @few_delayed = @fewest_delayed.entries.first

  #departing airport with most delayed flights
  tql = 'SELECT origin_city_name, COUNT(*) FROM airline_performance WHERE dep_delay_new > 0 GROUP BY origin_city_name ORDER BY count desc'
  @amd = db.exec(tql)
  @air_most_delayed = @amd.entries.first

  #departing airport with fewest delayed flights
  rql = 'SELECT origin_city_name, COUNT(*) FROM airline_performance WHERE dep_delay_new > 0 GROUP BY origin_city_name ORDER BY count asc'
  @afd = db.exec(rql)
  @air_few_delayed = @afd.entries.first

  #arriving airport with most delayed flights
  aql = 'SELECT origin_city_name, COUNT(*) FROM airline_performance WHERE arr_delay_new > 0 GROUP BY origin_city_name ORDER BY count desc'
  @aamd = db.exec(aql)
  @arr_air_most_delayed = @aamd.entries.first

  #arriving airport with fewest delayed flights
  bql = 'SELECT origin_city_name, COUNT(*) FROM airline_performance WHERE arr_delay_new > 0 GROUP BY origin_city_name ORDER BY count asc'
  @aafd = db.exec(bql)
  @arr_air_few_delayed = @aafd.entries.first

  #What was the average number of minutes late across all airports?
  cql = 'SELECT AVG(dep_delay_new) as DelayAverage FROM airline_performance'
  @avglate = db.exec(cql)
  @avg_min_late = @avglate.entries

  #What was the average number of minutes late for each airline?
  dql = 'SELECT carrier, AVG(dep_delay_new) FROM airline_performance GROUP BY carrier ORDER BY avg desc'
  @lateall = db.exec(dql)
  @avg_late_all = @lateall.entries

  erb :index
end



