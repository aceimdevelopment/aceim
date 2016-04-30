require 'test_helper'

class SegmentosControllerTest < ActionController::TestCase
  setup do
    @segmento = segmento(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:segmento)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create segmento" do
    assert_difference('Segmento.count') do
      post :create, :segmento => @segmento.attributes
    end

    assert_redirected_to segmento_path(assigns(:segmento))
  end

  test "should show segmento" do
    get :show, :id => @segmento.to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => @segmento.to_param
    assert_response :success
  end

  test "should update segmento" do
    put :update, :id => @segmento.to_param, :segmento => @segmento.attributes
    assert_redirected_to segmento_path(assigns(:segmento))
  end

  test "should destroy segmento" do
    assert_difference('Segmento.count', -1) do
      delete :destroy, :id => @segmento.to_param
    end

    assert_redirected_to segmentos_path
  end
end
