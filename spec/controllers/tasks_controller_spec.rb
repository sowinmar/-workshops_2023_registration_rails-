require 'rails_helper'

RSpec.describe TasksController, type: :controller do
  let(:task) { Task.last }

  describe "#new" do
    it "renders the new template" do
      get :new
      expect(response).to render_template(:new)
      expect(response).to have_http_status(:ok)
    end
  end

  describe '#create' do
    context "for no task attributes given" do
      it 'renders new template' do
        post :create, params: { task: { foo: 'bar' } }
        expect(response).to have_http_status(:ok)
        expect(response).to render_template(:new)
      end
    end

    context "for task attributes given" do
      it 'renders new template' do
        post :create, params: { task: { title: 'foo', description: 'bar' } }
        expect(response).to redirect_to tasks_url
        expect(flash[:notice]).to be_present
      end
    end
  end

  describe "#edit" do
    before { Task.create!(title: "foo", description: "bar")}

    it "renders the edit template" do
      get :edit, params: { id: task.id }

      expect(response).to render_template(:edit)
      expect(response).to have_http_status(:ok)
    end
  end

  describe '#update' do
    before { Task.create!(title: "foo", description: "bar")}

    context "proper atteributes given" do
      it 'update the task' do
        put :update, params: { id: task.id, task: { title: "foo_bar", description: "bar_edit" } }

        expect(response).to redirect_to tasks_url
        task.reload
        expect(task.title).to eq("foo_bar")
        expect(task.description).to eq("bar_edit")
        expect(flash.notice).to eq("Task successfully updated.")
      end
    end

    context "invalid attributes given" do
      it 'should fail to update the task' do
        put :update, params: { id: task.id, task: { title: "", description: "bar_edit" } }

        expect(response).to render_template(:edit)
        task.reload
        expect(task.title).to eq("foo")
      end
    end
  end

  describe "#index" do
    it "renders the index template" do
      get :index

      expect(response).to render_template(:index)
      expect(response).to have_http_status(:ok)
    end
  end
end
