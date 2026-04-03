class AttachmentSerializer
  class << self
    def render_collection(attachments)
      attachments.map do |attachment|
        attachment.slice("id", "title", "file_url", "content_type", "metadata")
      end
    end
  end
end
