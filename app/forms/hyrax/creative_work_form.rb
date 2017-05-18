# Generated via
#  `rails generate hyrax:work CreativeWork`
module Hyrax
  class CreativeWorkForm < Hyrax::Forms::WorkForm
    self.model_class = ::CreativeWork
    self.terms += [:resource_type]
  end
end
