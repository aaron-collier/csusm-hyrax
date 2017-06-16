# Generated via
#  `rails generate hyrax:work Newspaper`
module Hyrax
  class NewspaperPresenter < Hyrax::WorkShowPresenter
    delegate :date_issued, :sponsor, to: :solr_document
  end
end
