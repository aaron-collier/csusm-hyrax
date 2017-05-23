# Generated via
#  `rails generate hyrax:work Project`

module Hyrax
  class ProjectsController < ApplicationController
    # Adds Hyrax behaviors to the controller.
    include Hyrax::WorksControllerBehavior
    include Hyrax::BreadcrumbsForWorks
    self.curation_concern_type = ::Project

    self.show_presenter = ProjectShowPresenter

  end
end
