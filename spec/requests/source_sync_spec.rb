require "rails_helper"

RSpec.describe "Source sync API", type: :request do
  describe "POST /sources/:id/sync" do
    it "enqueues a sync job for the source" do
      source = create(:source)
      allow(SourceSyncJob).to receive(:perform_async)

      post "/sources/#{source.id}/sync"

      expect(response).to have_http_status(:accepted)
      expect(SourceSyncJob).to have_received(:perform_async).with(source.id)
      expect(json_body).to include("status" => "queued", "source_id" => source.id)
    end
  end
end
