class CsvImportController < ApplicationController
	
	def index
		# Render page
		respond_to do |format|
		format.html # index.html.erb
		end
	end
	
  def student_list
    # Render page
		respond_to do |format|
		format.html # student_list.html.erb
		end
  end
  
  def mark
    @experiments = {}
    Experiment.find(:all, :order => 'exp_num, id' ).each do |exp|
      @experiments["#{exp.exp_num}: #{exp.name}"] = exp.id
    end
    
    # Render page
		respond_to do |format|
		format.html # mark.html.erb
		end
  end
  
	def upload_student_list
		if request.post? && params[:csv].present?
			uploaded = params[:csv].read
			n = 0
      time = Time.new
      this_year = time.year
      this_semester = time.mon <= 6 ? 1 : 2
      
      save_success = true
			CSV.parse(uploaded) do |row|
        # Ignore the heading row and blank row
				n += 1
				next if n == 1 or row.join.blank?

        Student.transaction do
          # Create the student
          # format must be: sid, credit point, first name, last name, email
          student = Student.find_or_initialize_by_sid(row[0])
          student.attributes ={:sid => row[0], :cp => row[1], :first_name => row[2], :last_name => row[3], :email => row[4]}
    
          if (not student.save)
            save_success = false
            raise ActiveRecord::Rollback
          end
        
          # Add the student to current semester 
           student_semester = StudentSemester.where(:student_id => student.id, :semester => Rails.cache.read("semester"), :year => Rails.cache.read("year"))
          if student_semester.blank?
            student_semester = StudentSemester.new(:student => student, :semester => Rails.cache.read("semester"), :year => Rails.cache.read("year"))
          else
            student_semester = student_semester.first
          end
          
          # Create user account
          user = User.find_by_username(student.sid)
          if user.nil?
            user = User.new(username: student.sid, role: "student", details_id: student.sid)
          end
          temp_random_password = (('0'..'9').to_a + ('a'..'z').to_a).shuffle.first(8).join
          user.password = temp_random_password


          # Trying to save the data          
          if (not user.save) || (not student_semester.save)
            save_success = false
            raise ActiveRecord::Rollback
          else
            # Send an email to the user regarding the registration
            SystemMailer.registrationEmail(user.username, temp_random_password, student.email, root_url).deliver
          end
        end
      end
      
      if save_success
        redirect_to :action => :student_list, :notice => "Successfully import the student list."
      else
        redirect_to :action => :student_list, :error => "Unable to save some of the students."
      end
		else
			redirect_to :action => :student_list, :error => "Please select a valid .csv file"
		end
	end
  
  def upload_mark
		if request.post? && params[:csv].present?
			uploaded = params[:csv].read
      user = User.find_by_username(session[:username])
			n = 0
      
      error_message = nil
			CSV.parse(uploaded) do |row|
        # Ignore the heading row and blank row
				n += 1
				next if n == 1 or row.join.blank?

        # Create mark
        # format must be: sid, first name, last name, exp num, mark type, mark
        student = Student.find_by_sid(row[0])
        experiment = Experiment.find_by_exp_num(row[3].to_i)
        mark_type = row[4].strip
        if student.blank?
          error_message = 'Invalid studend ID: ' + row[0]
          break
        end
        if experiment.blank?
          error_message = 'Invalid experiment number: ' + row[3]
          break
        end

        mark = Mark.where(:student_id => student.id, :experiment_id => experiment.id, :mark_type => mark_type).first
        if mark.blank?
          mark = Mark.new(:experiment => experiment, :student => student, :user => user, :mark_type => mark_type, :mark => row[5].to_d)
        else
          mark.attributes ={:user => user, :mark => row[5].to_d }
        end
        if not mark.save
          error_message = mark.errors.first[1]
          break
        end
      end
      
      if error_message.nil?
        redirect_to :action => :mark, :notice => "Successfully import all student marks."
      else
        redirect_to :action => :mark, :error => error_message
      end
		else
			redirect_to :action => :mark, :error => "Please select a valid .csv file"
		end
	end
end
