class BubblesController < ApplicationController
  include BucketScoped

  before_action :set_bubble, only: %i[ show edit update ]
  before_action :clear_assignees, only: :index
  before_action :set_view, :set_filter, only: :index

  def index
    @bubbles = @filter.bubbles
  end

  def new
    @bubble = @bucket.bubbles.build
  end

  def create
    @bubble = @bucket.bubbles.create!
    redirect_to bucket_bubble_url(@bucket, @bubble)
  end

  def show
    fresh_when etag: @bubble
  end

  def edit
  end

  def update
    @bubble.update! bubble_params
    redirect_to bucket_bubble_url(@bucket, @bubble)
  end

  private
    def set_bubble
      @bubble = @bucket.bubbles.find params[:id]
    end

    def bubble_params
      params.expect(bubble: [ :title, :color, :due_on, :image, tag_ids: [] ])
    end

    def clear_assignees
      params[:assignee_ids] = nil if helpers.unassigned_filter_activated?
    end

    def set_view
      @view = @bucket.views.find_by(creator: Current.user, id: params[:view_id]) if params[:view_id]
      @view ||= @bucket.views.find_by(creator: Current.user, filters: helpers.bubble_filter_params.to_h)
      params[:view_id] = @view&.id
    end

    def set_filter
      @filter = @bucket.bubble_filter_from helpers.view_filter_params
    end
end
