class Cards::DueOnsController < ApplicationController
  include CardScoped

  def show
  end

  def update
    @card.update! due_on: params[:due_on]

    respond_to do |format|
      format.turbo_stream
      format.json { head :no_content }
    end
  end

  def destroy
    @card.update! due_on: nil

    respond_to do |format|
      format.turbo_stream
      format.json { head :no_content }
    end
  end
end
