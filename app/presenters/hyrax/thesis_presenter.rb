# Generated via
#  `rails generate hyrax:work Thesis`
module Hyrax
  class ThesisPresenter < Hyrax::WorkShowPresenter
    delegate :date_submitted, :handle, :college, :department, :university,
             :degree_level, :degree_name, :abstract, :advisor, :committee_member,
             :geographical_area, :time_period, :date_available, :date_copyright,
             :date_issued, :sponsor, :alternative_title, :statement_of_responsibility, to: :solr_document
  end
end
