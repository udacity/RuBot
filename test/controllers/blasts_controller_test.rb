require 'test_helper'

class BlastsControllerTest < ActionController::TestCase
  setup do
    @blast = blasts(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:blasts)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create blast" do
    assert_difference('Blast.count') do
      post :create, blast: { reach: @blast.reach, text: @blast.text }
    end

    assert_redirected_to blast_path(assigns(:blast))
  end

  test "should show blast" do
    get :show, id: @blast
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @blast
    assert_response :success
  end

  test "should update blast" do
    patch :update, id: @blast, blast: { reach: @blast.reach, text: @blast.text }
    assert_redirected_to blast_path(assigns(:blast))
  end

  test "should destroy blast" do
    assert_difference('Blast.count', -1) do
      delete :destroy, id: @blast
    end

    assert_redirected_to blasts_path
  end
end
