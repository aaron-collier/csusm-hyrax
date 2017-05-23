# Generated via
#  `rails generate hyrax:work Project`
module Hyrax
  class ProjectForm < Hyrax::Forms::WorkForm
    self.model_class = ::Project
    self.terms += [:resource_type, :date_submitted, :handle, :college,
      :department, :university, :degree_level, :degree_name, :abstract,
      :advisor, :committee_member, :geographical_area, :time_period,
      :date_available, :date_copyright, :date_issued, :sponsor,
      :alternative_title, :statement_of_responsibility]
  end
end
