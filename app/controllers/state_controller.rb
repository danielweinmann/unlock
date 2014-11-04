class StateController < ApplicationController

  private

  def transition_state(transition, redirect_path = nil)
    authorize resource
    model = resource.class.model_name.human.downcase
    if resource.send("can_#{transition}?")
      resource.send("#{transition}!")
      flash[:success] = "Status do #{model} alterado com sucesso!"
    else
      flash[:failure] = "Ooops. Não foi possível alterar o status do #{model}."
    end
    redirect_to redirect_path || resource
  end

end
