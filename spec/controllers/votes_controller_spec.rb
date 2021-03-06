require 'rails_helper'

describe VotesController do
  shared_examples 'render_index' do
    it 'assigns @contestants_ids with all the contestants' do
      expect(assigns :contestants).to_not be_nil
    end

    it 'renders the :index template' do
      expect(response).to render_template :index
    end
  end

  shared_examples 'render_result' do
    it 'renders the :result template' do
      expect(response).to render_template :result
    end
  end

  describe 'GET index' do
    context 'after finish' do
      before do
        allow(Poll).to receive(:finished?) { true }
        get :index
      end

      it 'set flash message informing the finish of the poll' do
        expect(flash[:info]).to eq I18n.t('votes.result.info.finish')
      end

      it 'redirects to :result' do
        expect(response).to redirect_to(action: 'result')
      end
    end

    context 'before finish' do
      before do
        allow(Poll).to receive(:finished?) { false }
        get :index
      end

      include_examples 'render_index'
    end
  end

  describe 'POST create' do
    context 'after finish' do
      before do
        allow(Poll).to receive(:finished?) { true }
        post :create
      end

      it 'set flash message informing the finish of the poll' do
        expect(flash[:info]).to eq I18n.t('votes.result.info.finish')
      end

      it 'redirects to :result' do
        expect(response).to redirect_to(action: 'result')
      end
    end

    context 'before finish' do
      before do
        allow(Poll).to receive(:finished?) { false }
      end

      context 'failing on recaptcha' do
        before do
          allow(controller).to receive(:verify_recaptcha) { false }
        end

        it 'does not continue with the vote recorder to record the vote' do
          expect_any_instance_of(Cache::Vote).to_not receive(:save)
          post :create
        end

        include_examples 'render_index' do
          before do
            post :create
          end
        end
      end

      context 'on success' do
        before do
          allow_any_instance_of(Cache::Vote).to receive(:save) { true }
          post :create, contestant: 1
        end

        it 'set flash with success message' do
          expect(flash[:success]).to_not be_nil
        end

        include_examples 'render_result'
      end

      context 'on error' do
        before do
          allow_any_instance_of(Cache::Vote).to receive(:save) { false }
        end

        it 'set flash with success message' do
          post :create, contestant: 1
          expect(flash[:error]).to_not be_nil
        end

        include_examples 'render_index' do
          before do
            post :create, contestant: 1
          end
        end
      end
    end
  end

  describe 'GET result' do
    before do
      get :result
    end

    include_examples 'render_result'
  end
end
