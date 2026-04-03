class SourcesController < ApplicationController
  def sync
    source = Source.find(params[:id])
    SourceSyncJob.perform_async(source.id)

    render json: { status: "queued", source_id: source.id }, status: :accepted
  end
end
