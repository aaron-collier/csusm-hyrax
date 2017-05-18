# Generated via
#  `rails generate hyrax:work Project`
module Hyrax
  class ProjectForm < Hyrax::Forms::WorkForm
    self.model_class = ::Project
    self.terms += [:resource_type]
  end
end
