# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

# Add admin into the user list, the password is defaulted to "admin"
User.create(username: 'admin', password: 'admin', role: 'admin', details_id: 1)

# Add all the controller here
# The order of this list determine the order that the entry appears in the menu
# class_name: name of the controller
# admin: admin will always has the right to access a controller, however, this value set whether the controller is showing up in the menu
# tutor & student: permission for tutor or student to access this controller (admin is defaulted to be able to use every controller)
# menu_controller & menu_action: this is used to render the link to the controller. Normally, the controller is the controller file name and action is the function that will be called
# display_text: the text to be displayed to the user
Permission.create(class_name: 'HomeController',                     admin: true,  tutor: true,  student: true,  menu_controller: 'home',                      menu_action: 'index',          display_text: 'Home')
Permission.create(class_name: 'CalendarController',                 admin: true,  tutor: false, student: false, menu_controller: 'calendars',                 menu_action: 'index',          display_text: 'Calendar')
Permission.create(class_name: 'TutorsController',                   admin: true,  tutor: false, student: false, menu_controller: 'tutors',                    menu_action: 'index',          display_text: 'Tutors')
Permission.create(class_name: 'StudentsController',                 admin: true,  tutor: false, student: false, menu_controller: 'students',                  menu_action: 'index',          display_text: 'Students')

Permission.create(class_name: 'ExperimentsController',              admin: true,  tutor: false, student: false, menu_controller: 'experiments',               menu_action: 'index',          display_text: 'Experiments')
Permission.create(class_name: 'ExperimentAvailabilitiesController', admin: true,  tutor: false, student: false, menu_controller: 'experiment_availabilities', menu_action: 'index',          display_text: 'Change Experiment Availability')
# Admin has permission to add booking, but I don't want the item to appear in the menu (will cause syntax error)
Permission.create(class_name: 'MakeBookingController',              admin: false, tutor: false, student: true,  menu_controller: 'make_booking',              menu_action: 'index',          display_text: 'Book Experiment')
Permission.create(class_name: 'BookingsController',                 admin: true,  tutor: false, student: true,  menu_controller: 'bookings',                  menu_action: 'index',          display_text: 'Bookings Summary')

Permission.create(class_name: 'UploadReportsController',            admin: false, tutor: false, student: true,  menu_controller: 'upload_reports',            menu_action: 'index',          display_text: 'Upload Report')
Permission.create(class_name: 'DownloadRerportsController',         admin: true,  tutor: true,  student: false, menu_controller: 'download_reports',          menu_action: 'index',          display_text: 'Download Report')

Permission.create(class_name: 'MarksController',                    admin: true,  tutor: true,  student: false, menu_controller: 'marks',                     menu_action: 'index',          display_text: 'Student Marks')
Permission.create(class_name: 'ResultsController',                  admin: false, tutor: false, student: true,  menu_controller: 'results',                   menu_action: 'index',          display_text: 'My Marks')
Permission.create(class_name: 'CreditPointController',              admin: true,  tutor: false, student: false, menu_controller: 'credit_points',             menu_action: 'index',          display_text: 'Set up CP requirement')

Permission.create(class_name: 'CsvImportController',                admin: true,  tutor: false, student: false, menu_controller: 'csv_import',                menu_action: 'index',          display_text: 'Import CSV')
Permission.create(class_name: 'CsvExportController',                admin: true,  tutor: false, student: false, menu_controller: 'csv_export',                menu_action: 'index',          display_text: 'Export CSV')

Permission.create(class_name: 'SettingController',                  admin: true,  tutor: false, student: false, menu_controller: 'settings',                  menu_action: 'index',          display_text: 'System Settings')
Permission.create(class_name: 'PermissionsController',              admin: false, tutor: false, student: false, menu_controller: 'permissions',               menu_action: 'index',          display_text: 'User Permissions')

Permission.create(class_name: 'UsersController',                    admin: true,  tutor: true,  student: true,  menu_controller: 'users',                     menu_action: 'change_details', display_text: 'Change Password and Details')
Permission.create(class_name: 'LoginController',                    admin: true,  tutor: true,  student: true,  menu_controller: 'login',                     menu_action: 'logout',         display_text: 'Logout')



# Default setting
Setting.create(name: "sem_start",   string: nil, integer: nil, decimal: nil, date: Date.parse('2014-07-30'))
Setting.create(name: "sem_end",     string: nil, integer: nil, decimal: nil, date: Date.parse('2014-11-02'))
Setting.create(name: "break_start", string: nil, integer: nil, decimal: nil, date: Date.parse('2014-09-22'))
Setting.create(name: "break_end",   string: nil, integer: nil, decimal: nil, date: Date.parse('2014-10-01'))

Setting.create(name: "max_booking",            string: nil, integer: 3, decimal: nil, date: nil)
Setting.create(name: "min_day_cancel_booking", string: nil, integer: 7, decimal: nil, date: nil)

# Credit Point requirement preset
CreditPoint.create(cp: 2, experiment:  3, report: 1, poster: 0, talk: 0, assignment: 1)
CreditPoint.create(cp: 4, experiment:  5, report: 2, poster: 0, talk: 1, assignment: 1)
CreditPoint.create(cp: 6, experiment:  8, report: 2, poster: 1, talk: 1, assignment: 1)
CreditPoint.create(cp: 8, experiment: 10, report: 3, poster: 1, talk: 2, assignment: 1)
