# Generated via
#  `rails generate hyrax:work CreateWork`

module Hyrax
  class CreativeWorksController < ApplicationController
    # Adds Hyrax behaviors to the controller.
    include Hyrax::WorksControllerBehavior
    include Hyrax::BreadcrumbsForWorks
    self.curation_concern_type = ::CreativeWork

    # Use this line if you want to use a custom presenter
    self.show_presenter = Hyrax::CreativeWorkPresenter
  end
end
