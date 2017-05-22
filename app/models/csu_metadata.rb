# Generated via
#  `rails generate hyrax:work FacultyWork`
module CsuMetadata
  extend ActiveSupport::Concern

  included do

    property :abstract, predicate: ::RDF::Vocab::DC.abstract do |index|
      index.as :stored_searchable, :facetable
    end

    property :advisor, predicate: ::RDF::Vocab::MARCRelators.ths do |index|
      index.as :stored_searchable, :facetable
    end

    property :alternative_title, predicate: ::RDF::Vocab::DC.alternative do |index|
      index.as :stored_searchable, :facetable
    end

    property :committee_member, predicate: ::RDF::Vocab::MARCRelators.ctb do |index|
      index.as :stored_searchable, :facetable
    end

    property :date_available, predicate: ::RDF::Vocab::DC.available do |index|
      index.as :stored_searchable, :facetable
    end

    property :date_copyright, predicate: ::RDF::Vocab::DC.dateCopyrighted do |index|
      index.as :stored_searchable, :facetable
    end

    property :date_issued, predicate: ::RDF::Vocab::DC.issued do |index|
      index.as :stored_searchable, :facetable
    end

    property :date_submitted, predicate: ::RDF::Vocab::DC.date do |index|
      index.as :stored_searchable, :facetable
    end

    property :geographical_area, predicate: ::RDF::Vocab::DC.spatial do |index|
      index.as :stored_searchable, :facetable
    end

    property :handle, predicate: ::RDF::Vocab::PREMIS.ContentLocation do |index|
      index.as :stored_searchable, :facetable
    end

    property :is_part_of, predicate: ::RDF::Vocab::DC.relation do |index|
      index.as :stored_searchable, :facetable
    end

    property :sponsor, predicate: ::RDF::Vocab::MARCRelators.spn do |index|
      index.as :stored_searchable, :facetable
    end

    property :statement_of_responsibility, predicate: ::RDF::Vocab::MARCRelators.rpy do |index|
      index.as :stored_searchable, :facetable
    end

    property :time_period, predicate: ::RDF::Vocab::DC.temporal do |index|
      index.as :stored_searchable, :facetable
    end

    property :extent, predicate: ::RDF::Vocab::DC.extent do |index|
      index.as :stored_searchable, :facetable
    end

    property :provenance, predicate: ::RDF::Vocab::DC.provenance
    property :date_accessioned, predicate: ::RDF::Vocab::DC.date, multiple: false
    property :embargo_terms, predicate: ::RDF::Vocab::DC.description, multiple: false
  end
end
