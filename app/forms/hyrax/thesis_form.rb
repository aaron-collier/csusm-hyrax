# Generated via
#  `rails generate hyrax:work Thesis`
module Hyrax
  class ThesisForm < Hyrax::Forms::WorkForm
    self.model_class = ::Thesis
    self.terms += [:resource_type, :date_submitted, :handle, :college,
      :department, :degree_level, :degree_name, :advisor, :committee_member,
      :date_issued, :alternative_title, :statement_of_responsibility]

    self.terms -= [:contributor, :subject, :license, :publisher, :date_created,
                   :identifier, :location, :related_url, :source, :handle, :based_near]

    self.required_fields += [:date_submitted, :resource_type, :college, :department,
                             :degree_level, :degree_name, :abstract, :description]

    self.required_fields -= [:rights_statement]

    def primary_terms
      [:creator, :title, :alternative_title, :description, :date_issued, :date_submitted,
       :resource_type, :advisor, :committee_member, :college, :department, :degree_level,
       :degree_name, :keyword, :language, :rights_statement, :statement_of_responsibility]
    end
  end
end
