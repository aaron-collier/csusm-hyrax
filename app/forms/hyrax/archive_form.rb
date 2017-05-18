# Generated via
#  `rails generate hyrax:work Archive`
module Hyrax
  class ArchiveForm < Hyrax::Forms::WorkForm
    self.model_class = ::Archive
    self.terms += [:resource_type]
  end
end
