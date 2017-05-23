# Generated via
#  `rails generate hyrax:work Dissertation`
module Hyrax
  class DissertationForm < Hyrax::Forms::WorkForm
    self.model_class = ::Dissertation
    self.terms += [:resource_type]
    self.terms += [:resource_type, :date_submitted, :handle, :college,
      :department, :university, :degree_level, :degree_name, :abstract,
      :advisor, :committee_member, :geographical_area, :time_period,
      :date_available, :date_copyright, :date_issued, :sponsor,
      :alternative_title, :statement_of_responsibility]
  end
end
