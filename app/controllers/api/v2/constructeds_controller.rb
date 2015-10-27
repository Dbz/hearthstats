class Api::V2::ConstructedsController < ApplicationController
  before_filter :authenticate_user!
  before_filter :get_req

  respond_to :json

  def show
    render json: "hello"
  end

  def new
    render json: { status: "fail", message: "Please update your uploader."}
  end
end
