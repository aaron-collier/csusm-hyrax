# Generated via
#  `rails generate hyrax:work Archive`
class Archive < ActiveFedora::Base
  include ::Hyrax::WorkBehavior
  include ::Hyrax::BasicMetadata
  include ::CsuMetadata

  self.indexer = ArchiveIndexer
  # Change this to restrict which works can be added as a child.
  # self.valid_child_concerns = []
  validates :title, presence: { message: 'Your work must have a title.' }

  self.human_readable_type = 'Archive'
end
