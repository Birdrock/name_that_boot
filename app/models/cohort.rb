class Cohort
  attr_accessor :id, :name, :start_date

  def initialize(data = {})
    @id = data[:id]
    @name = data[:name]
    @start_date = Date.parse(data[:start_date])
  end

  def self.find_active_cohorts
    @cohorts = DBC::Cohort.all.select{ |cohort| cohort.in_session && !cohort.name.downcase.include?("melt") }
    @cohorts.map!{|cohort| Cohort.new({id: cohort.id, name: cohort.name, start_date: cohort.start_date}) }
  end

  def self.find_active_cohorts_by_date
    Cohort.find_active_cohorts.sort_by{ |cohort| cohort.start_date }.reverse!
  end

end
