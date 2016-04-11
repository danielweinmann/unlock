require 'rails_helper'

RSpec.describe Initiatives::ContributionsController, type: :controller do
  render_views

  subject{ response }
  let(:user){ nil }

  let(:initiative) { unlock_initiative }
  let(:gateway) { initiative.gateways.first }

  before do
    allow(controller).to receive(:current_user).and_return(user)
    allow(controller).to receive(:set_locale).and_return(nil)
  end

  describe "#index" do
    let(:contributions) { initiative.contributions.visible }
    let(:user) { initiative.user }

    before {
      get :index, initiative_id: initiative.id
    }

    it { expect(assigns(:contributions)).to eq(contributions) }
    it { is_expected.to render_template(:index) }
  end

  describe "#show" do
    let(:user) { initiative.user }
    let(:contribution) { get_contribution('active') }

    before {
      get :show, id: contribution.id, initiative_id: initiative.id
    }

    it { expect(assigns(:contribution)).to eq(contribution) }
    it { expect(assigns(:user)).to eq(contribution.user) }
    it { is_expected.to render_template(:show) }
  end

  describe "#show.json" do
    let(:user) { initiative.user }
    let(:contribution) { get_contribution('active') }
    let(:body) { JSON.parse(response.body) }

    before {
      contribution.update_attributes(hide_value: true)
      get :show, id: contribution.id, initiative_id: initiative.id, format: :json
    }

    it { expect(body['id']).to eq(contribution.id) }
    it { expect(body['state']).to eq(contribution.state) }
    it { expect(body['hide_value']).to eq(true) }

    context "Logged out users can't see contribution value with hide_value=true" do
      let(:user) { nil }
      it { expect(body['value']).to eq(nil) }
    end

    context "Unrelated user user can't see contribution value with hide_value=true" do
      let(:user) { get_user('new_user') }
      it { expect(body['value']).to eq(nil) }
    end

  end

end
