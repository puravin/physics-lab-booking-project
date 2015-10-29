class ResultsController < ApplicationController
  def index
    # Get a list of experiment the student booked
    sem_start   = Setting.getSetting('sem_start', 'date')
    sem_end     = Setting.getSetting('sem_end', 'date')
      
    @student = Student.find_by_sid(session[:username])
    current_marks = @student.marks.where(:updated_at => (sem_start .. sem_end))
    @current_mark = computeMark(current_marks)
    
    previous_marks = @student.marks.where(:updated_at => (DateTime.new(2007,1,1) .. sem_start))
    @previous_mark = computeMark(previous_marks)
    
    # Render page
    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @results }
    end
  end
  
  def computeMark(marks)
    experiment_set = Set.new
    marks.each do |b|
      experiment_set.add(b.experiment)
    end
    
    experiment = experiment_set.to_a
    mark_table = Array.new(experiment.length)
    
    # hash for mark type
    mark_type_hash = Hash.new
    mark_type_hash['experiment'] = 1
    mark_type_hash['report'] = 2
    mark_type_hash['poster'] = 3
    mark_type_hash['talk'] = 4
    mark_type_hash['assignment'] = 5
    
    # Generate the table for marks
    for i in 0 .. (experiment.length - 1) do
      marks = experiment[i].marks.where(:student_id => @student.id)
      row = Array.new(6, '')
      mark_table[i] = row
      
      row[0] = experiment[i]
      
      marks.each do |m|
        index = mark_type_hash[m.mark_type]
        row[index] = m.mark
      end
    end
    
    return mark_table
  end
end
