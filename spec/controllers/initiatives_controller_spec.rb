require 'rails_helper'

RSpec.describe InitiativesController, type: :controller do
  subject{ response }
  let(:user){ nil }

  before do
    allow(controller).to receive(:current_user).and_return(user)
  end

  describe "GET index" do
    before do
      get :index
    end

    it{ is_expected.to be_successful }
  end

  describe "GET show" do
    before do
      get :show, id: unlock_initiative.permalink
    end

    it{ is_expected.to redirect_to initiative_by_permalink_path(unlock_initiative) }
  end

  describe "GET new" do
    before do
      get :new
    end
  end

  describe "PATCH update" do
    before do
    end
  end

  describe "PUT publish" do
    before do
    end
  end

  describe "PUT revert_to_draft" do
    before do
    end
  end

end
