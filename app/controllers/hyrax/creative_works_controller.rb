# Generated via
#  `rails generate hyrax:work CreativeWork`

module Hyrax
  class CreativeWorksController < ApplicationController
    # Adds Hyrax behaviors to the controller.
    include Hyrax::WorksControllerBehavior
    include Hyrax::BreadcrumbsForWorks
    self.curation_concern_type = ::CreativeWork
  end
end
