# Generated via
#  `rails generate hyrax:work Thesis`
module Hyrax
  class ThesisForm < Hyrax::Forms::WorkForm
    self.model_class = ::Thesis
    self.terms += [:resource_type, :date_submitted, :handle, :college,
      :department, :university, :degree_level, :degree_name, :abstract,
      :advisor, :committee_member, :geographical_area, :time_period,
      :date_available, :date_copyright, :date_issued, :sponsor,
      :alternative_title, :statement_of_responsibility]

    self.required_fields += [:date_submitted, :resource_type, :university,
                             :college, :department, :degree_level,
                             :degree_name, :abstract]

    self.required_fields -= [:rights_statement]
  end
end
