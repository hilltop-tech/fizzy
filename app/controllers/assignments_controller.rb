class AssignmentsController < ApplicationController
  include BubbleScoped, BucketScoped

  def new
  end

  def show
  end

  def create
    @bubble.assign(find_assignee)
    redirect_to @bubble
  end

  private
    def find_assignee
      @bucket.users.active.find(params.expect(:assignee_id))
    end
end
