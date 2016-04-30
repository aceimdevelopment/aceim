require 'test_helper'

class ExamenesControllerTest < ActionController::TestCase
  setup do
    @examen = examen(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:examen)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create examen" do
    assert_difference('Examen.count') do
      post :create, :examen => @examen.attributes
    end

    assert_redirected_to examen_path(assigns(:examen))
  end

  test "should show examen" do
    get :show, :id => @examen.to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => @examen.to_param
    assert_response :success
  end

  test "should update examen" do
    put :update, :id => @examen.to_param, :examen => @examen.attributes
    assert_redirected_to examen_path(assigns(:examen))
  end

  test "should destroy examen" do
    assert_difference('Examen.count', -1) do
      delete :destroy, :id => @examen.to_param
    end

    assert_redirected_to examenes_path
  end
end
