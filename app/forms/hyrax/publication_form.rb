# Generated via
#  `rails generate hyrax:work Publication`
module Hyrax
  class PublicationForm < Hyrax::Forms::WorkForm
    self.model_class = ::Publication
    self.terms += [:resource_type, :sponsor, :date_issued, :alternative_title, :statement_of_responsibility]

    self.terms -= [:contributor, :date_created, :identifier, :license, :based_near, :source]

    self.required_fields += [:date_issued, :resource_type, :description]

    self.required_fields -= [:rights_statement]

    def primary_terms
      [:creator, :title, :alternative_title, :description, :date_issued, :publisher,
       :resource_type, :subject, :keyword, :language, :sponsor, :rights_statement,
       :bibliographic_citation, :related_url, :statement_of_responsibility]
    end  end
end
