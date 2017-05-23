# Generated via
#  `rails generate hyrax:work Dissertation`
class Dissertation < ActiveFedora::Base
  include ::Hyrax::WorkBehavior
  include ::Hyrax::BasicMetadata
  include ::CsuMetadata
  include ::EtdMetadata

  self.indexer = DissertationIndexer
  # Change this to restrict which works can be added as a child.
  # self.valid_child_concerns = []
  validates :title, presence: { message: 'Your work must have a title.' }

  self.human_readable_type = 'Dissertation'
end
