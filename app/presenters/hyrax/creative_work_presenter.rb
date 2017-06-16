# Generated via
#  `rails generate hyrax:work CreateWork`
module Hyrax
  class CreativeWorkPresenter < Hyrax::WorkShowPresenter
    delegate :sponsor, to: :solr_document
  end
end
