# Generated via
#  `rails generate hyrax:work Newspaper`

module Hyrax
  class NewspapersController < ApplicationController
    # Adds Hyrax behaviors to the controller.
    include Hyrax::WorksControllerBehavior
    include Hyrax::BreadcrumbsForWorks
    self.curation_concern_type = ::Newspaper

    # Use this line if you want to use a custom presenter
    self.show_presenter = Hyrax::NewspaperPresenter
  end
end
