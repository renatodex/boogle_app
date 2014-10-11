class Page
  include MongoMapper::Document

  key :pageId
  key :content
end
# Page.ensure_index [[:pageId, 1]], :unique => true
