class StateController < ApplicationController

  private

  def transition_state(resource, transition, redirect_path = nil)
    authorize resource
    resource_name = resource.class.model_name.human
    if resource.send("can_#{transition}?")
      resource.send("#{transition}!")
      flash[:notice] = t('flash.actions.update.notice', resource_name: resource_name)
    else
      flash[:alert] = t('flash.actions.update.alert', resource_name: resource_name)
    end
    redirect_to (redirect_path || resource)
  end

end
