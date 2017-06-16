# Generated via
#  `rails generate hyrax:work Newspaper`
class Newspaper < ActiveFedora::Base
  include ::Hyrax::WorkBehavior
  # This must come after the WorkBehavior because it finalizes the metadata
  # schema (by adding accepts_nested_attributes)
  include ::CsuMetadata
  
  include ::Hyrax::BasicMetadata

  self.indexer = NewspaperIndexer
  # Change this to restrict which works can be added as a child.
  # self.valid_child_concerns = []
  validates :title, presence: { message: 'Your work must have a title.' }

  self.human_readable_type = 'Newspaper'
end
