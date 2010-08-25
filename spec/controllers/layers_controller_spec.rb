require 'spec_helper'

describe LayersController do

  def mock_layer(stubs={})
    @mock_layer ||= mock_model(Layer, stubs).as_null_object
  end

  describe "GET index" do
    it "assigns all layers as @layers" do
      Layer.stub(:all) { [mock_layer] }
      get :index
      assigns(:layers).should eq([mock_layer])
    end
  end

  describe "GET show" do
    it "assigns the requested layer as @layer" do
      Layer.stub(:find).with("37") { mock_layer }
      get :show, :id => "37"
      assigns(:layer).should be(mock_layer)
    end
  end

  describe "GET new" do
    it "assigns a new layer as @layer" do
      Layer.stub(:new) { mock_layer }
      get :new
      assigns(:layer).should be(mock_layer)
    end
  end

  describe "GET edit" do
    it "assigns the requested layer as @layer" do
      Layer.stub(:find).with("37") { mock_layer }
      get :edit, :id => "37"
      assigns(:layer).should be(mock_layer)
    end
  end

  describe "POST create" do

    describe "with valid params" do
      it "assigns a newly created layer as @layer" do
        Layer.stub(:new).with({'these' => 'params'}) { mock_layer(:save => true) }
        post :create, :layer => {'these' => 'params'}
        assigns(:layer).should be(mock_layer)
      end

      it "redirects to the created layer" do
        Layer.stub(:new) { mock_layer(:save => true) }
        post :create, :layer => {}
        response.should redirect_to(layer_url(mock_layer))
      end
    end

    describe "with invalid params" do
      it "assigns a newly created but unsaved layer as @layer" do
        Layer.stub(:new).with({'these' => 'params'}) { mock_layer(:save => false) }
        post :create, :layer => {'these' => 'params'}
        assigns(:layer).should be(mock_layer)
      end

      it "re-renders the 'new' template" do
        Layer.stub(:new) { mock_layer(:save => false) }
        post :create, :layer => {}
        response.should render_template("new")
      end
    end

  end

  describe "PUT update" do

    describe "with valid params" do
      it "updates the requested layer" do
        Layer.should_receive(:find).with("37") { mock_layer }
        mock_layer.should_receive(:update_attributes).with({'these' => 'params'})
        put :update, :id => "37", :layer => {'these' => 'params'}
      end

      it "assigns the requested layer as @layer" do
        Layer.stub(:find) { mock_layer(:update_attributes => true) }
        put :update, :id => "1"
        assigns(:layer).should be(mock_layer)
      end

      it "redirects to the layer" do
        Layer.stub(:find) { mock_layer(:update_attributes => true) }
        put :update, :id => "1"
        response.should redirect_to(layer_url(mock_layer))
      end
    end

    describe "with invalid params" do
      it "assigns the layer as @layer" do
        Layer.stub(:find) { mock_layer(:update_attributes => false) }
        put :update, :id => "1"
        assigns(:layer).should be(mock_layer)
      end

      it "re-renders the 'edit' template" do
        Layer.stub(:find) { mock_layer(:update_attributes => false) }
        put :update, :id => "1"
        response.should render_template("edit")
      end
    end

  end

  describe "DELETE destroy" do
    it "destroys the requested layer" do
      Layer.should_receive(:find).with("37") { mock_layer }
      mock_layer.should_receive(:destroy)
      delete :destroy, :id => "37"
    end

    it "redirects to the layers list" do
      Layer.stub(:find) { mock_layer }
      delete :destroy, :id => "1"
      response.should redirect_to(layers_url)
    end
  end

end
