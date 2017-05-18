# Generated via
#  `rails generate hyrax:work Archive`

module Hyrax
  class ArchivesController < ApplicationController
    # Adds Hyrax behaviors to the controller.
    include Hyrax::WorksControllerBehavior
    include Hyrax::BreadcrumbsForWorks
    self.curation_concern_type = ::Archive
  end
end
