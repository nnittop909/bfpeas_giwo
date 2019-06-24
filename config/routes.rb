Rails.application.routes.draw do

	resources :employees,          only: [:index, :show, :new, :create, :edit, :update] do
		resources :account_settings, only: [:index, :edit, :update], module: :employees
		resources :details,          only: [:edit, :update],         module: :employees
		resources :position_titles,  only: [:new, :create],          module: :employees
		resources :addresses,        only: [:new, :create],          module: :employees
		resources :contacts,         only: [:new, :create],          module: :employees
		resources :id_cards,         only: [:new, :create],          module: :employees
		resources :avatars,          only: [:update],                module: :employees
		resources :settings,         only: [:index],                 module: :employees
		resources :schedules,        only: [:edit, :update],         module: :employees
		resources :departments,      only: [:edit, :update],         module: :employees
		resources :license_and_insurances, only: [:new, :create, :edit, :update], module: :employees
		resources :emergency_contacts, only: [:new, :create, :edit, :update], module: :employees
		resources :time_records,     only: [:index, :new, :create],  module: :employees
		resources :log_details,      only: [:index],                 module: :employees
		resources :finger_prints,    only: [:index, :new, :create],  module: :employees
	end
	namespace :employees do
		resources :imports, only: [:create]
	end

	resources :monitoring, only: [:index]
	resources :reports, only: [:index]
	namespace :reports do
		resources :attendances, only: [:index]
		resources :employee_informations, only: [:index]
		resources :attendance_summaries, only: [:index]
		resources :daily_time_records, only: [:index]
	end
	
	resources :settings, only: [:index]
	namespace :settings do
		resources :holidays, only: [:new, :create, :edit, :update, :destroy]
		resources :business_hours,   only: [:new, :create, :edit, :update]
		resources :configurations,   only: [:new, :create, :edit, :update]
		resources :overtime_configs, only: [:new, :create, :edit, :update]
		resources :schedules,        only: [:new, :create, :edit, :update]
		resources :departments,      only: [:new, :create, :edit, :update]
		resources :signatories,      only: [:edit, :update]
	end

	devise_for :employees, path: 'employee_users', :controllers => { :registrations => "employee_users", sessions: "employee_users/sessions" }

	devise_scope :employee do
		authenticated do
	    root :to => 'employees#index', as: :authenticated_root
	  end

	  unauthenticated  do
	    root :to => 'monitoring#index', as: :unauthenticated_root
	  end
	end
end
