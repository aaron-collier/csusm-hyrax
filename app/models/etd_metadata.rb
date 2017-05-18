# Generated via
#  `rails generate hyrax:work FacultyWork`
module EtdMetadata
  extend ActiveSupport::Concern

  included do

    property :college, predicate: ::RDF::Vocab::SCHEMA.CollegeOrUniversity do |index|
      index.as :stored_searchable, :facetable
    end

    property :department, predicate: ::RDF::Vocab::SCHEMA.department do |index|
      index.as :stored_searchable, :facetable
    end

    property :university, predicate: ::RDF::Vocab::MARCRelators.dgg do |index|
      index.as :stored_searchable, :facetable
    end

    property :degree_level, predicate: ::RDF::Vocab::DC.educationLevel do |index|
      index.as :stored_searchable, :facetable
    end

    property :degree_name, predicate: ::RDF::Vocab::BIBO.degree do |index|
      index.as :stored_searchable, :facetable
    end
  end
end
