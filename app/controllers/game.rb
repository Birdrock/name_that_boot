before /game[\/a-z0-9]*/ do
  authenticate!
end

get '/game' do
  @cohorts = Cohort.find_active_cohorts_by_date
  erb :game
end

post '/game/deck/new' do
  @students = Student.find_students_by_cohort_id(params[:cohort_id])
  @students.to_json
end