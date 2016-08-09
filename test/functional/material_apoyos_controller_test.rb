require 'test_helper'

class MaterialApoyosControllerTest < ActionController::TestCase
  setup do
    @material_apoyo = material_apoyo(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:material_apoyo)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create material_apoyo" do
    assert_difference('MaterialApoyo.count') do
      post :create, material_apoyo: @material_apoyo.attributes
    end

    assert_redirected_to material_apoyo_path(assigns(:material_apoyo))
  end

  test "should show material_apoyo" do
    get :show, id: @material_apoyo.to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @material_apoyo.to_param
    assert_response :success
  end

  test "should update material_apoyo" do
    put :update, id: @material_apoyo.to_param, material_apoyo: @material_apoyo.attributes
    assert_redirected_to material_apoyo_path(assigns(:material_apoyo))
  end

  test "should destroy material_apoyo" do
    assert_difference('MaterialApoyo.count', -1) do
      delete :destroy, id: @material_apoyo.to_param
    end

    assert_redirected_to material_apoyos_path
  end
end
