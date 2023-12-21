module Voted
  extend ActiveSupport::Concern

  include do
    before_action :set_vottable, only: [:create]
  end

  def vottable_name
    params[:vottable]
  end

  def set_votable
    @vattable = vottable_name.classify.constantize.find(params[:id])
  end
end
