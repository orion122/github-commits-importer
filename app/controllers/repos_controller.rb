class ReposController < ApplicationController
  def index
    @owner = Owner.find(params[:owner_id])
    @repos = Repo.where(owner_id: params[:owner_id]).includes(:owner)
  end
end
