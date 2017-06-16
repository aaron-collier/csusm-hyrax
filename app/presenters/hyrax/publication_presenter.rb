# Generated via
#  `rails generate hyrax:work Publication`
module Hyrax
  class PublicationPresenter < Hyrax::WorkShowPresenter
    delegate :date_issued, :sponsor, :alternative_title, :statement_of_responsibility, to: :solr_document
  end
end
