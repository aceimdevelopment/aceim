require 'test_helper'

class TipoSegmentosControllerTest < ActionController::TestCase
  setup do
    @tipo_segmento = tipo_segmento(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:tipo_segmento)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create tipo_segmento" do
    assert_difference('TipoSegmento.count') do
      post :create, :tipo_segmento => @tipo_segmento.attributes
    end

    assert_redirected_to tipo_segmento_path(assigns(:tipo_segmento))
  end

  test "should show tipo_segmento" do
    get :show, :id => @tipo_segmento.to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => @tipo_segmento.to_param
    assert_response :success
  end

  test "should update tipo_segmento" do
    put :update, :id => @tipo_segmento.to_param, :tipo_segmento => @tipo_segmento.attributes
    assert_redirected_to tipo_segmento_path(assigns(:tipo_segmento))
  end

  test "should destroy tipo_segmento" do
    assert_difference('TipoSegmento.count', -1) do
      delete :destroy, :id => @tipo_segmento.to_param
    end

    assert_redirected_to tipo_segmentos_path
  end
end
