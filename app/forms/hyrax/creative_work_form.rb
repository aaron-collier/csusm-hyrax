# Generated via
#  `rails generate hyrax:work CreateWork`
module Hyrax
  class CreativeWorkForm < Hyrax::Forms::WorkForm
    self.model_class = ::CreativeWork
    self.terms += [:resource_type, :sponsor]

    self.terms -= [:contributor, :date_created, :identifier, :location, :related_url, :source, :handle, :based_near, :license]

    self.required_fields += [:date_issued, :resource_type]

    self.required_fields -= [:rights_statement, :keyword, :license]

    def primary_terms
      [:creator, :title, :description, :date_issued, :sponsor,
        :resource_type, :subject, :language, :rights_statement, :keyword]
    end
  end
end
