# Generated via
#  `rails generate hyrax:work Project`
class Project < ActiveFedora::Base
  include ::Hyrax::WorkBehavior
  include ::Hyrax::BasicMetadata
  include ::CsuMetadata
  include ::EtdMetadata

  self.indexer = ProjectIndexer
  # Change this to restrict which works can be added as a child.
  # self.valid_child_concerns = []
  validates :title, presence: { message: 'Your work must have a title.' }

  self.human_readable_type = 'Project'
end
