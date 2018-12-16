class ReposController < ApplicationController
  def index
    @repos = Repo.where(owner_id: params[:owner_id])
  end
end
