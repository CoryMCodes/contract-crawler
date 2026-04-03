class OpportunitiesController < ApplicationController
  def index
    opportunities = Search::OpportunitySearch.new(
      relation: Opportunity.includes(:source, :buyer),
      params: search_params
    ).call

    render json: { data: OpportunitySerializer.render_collection(opportunities) }
  end

  def show
    opportunity = Opportunity.includes(:awards, :attachments, :buyer, :source).find(params[:id])

    render json: {
      data: OpportunitySerializer.render_detail(opportunity),
      included: {
        awards: AwardSerializer.render_collection(opportunity.awards),
        attachments: AttachmentSerializer.render_collection(opportunity.attachments)
      }
    }
  end

  private

  def search_params
    params.permit(:q, :source, :state, :status, :due_before, :due_after)
  end
end
