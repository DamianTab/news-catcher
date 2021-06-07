defmodule Catcher.AccountTest do
  use Catcher.DataCase

  alias Catcher.Account

  describe "users" do
    alias Catcher.Account.User

    @valid_attrs %{email: "some email", nick: "some nick"}
    @update_attrs %{email: "some updated email", nick: "some updated nick"}
    @invalid_attrs %{email: nil, nick: nil}

    def user_fixture(attrs \\ %{}) do
      {:ok, user} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Account.create_user()

      user
    end

    test "list_users/0 returns all users" do
      user = user_fixture()
      assert Account.list_users() == [user]
    end

    test "get_user!/1 returns the user with given id" do
      user = user_fixture()
      assert Account.get_user!(user.id) == user
    end

    test "create_user/1 with valid data creates a user" do
      assert {:ok, %User{} = user} = Account.create_user(@valid_attrs)
      assert user.email == "some email"
      assert user.nick == "some nick"
    end

    test "create_user/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Account.create_user(@invalid_attrs)
    end

    test "update_user/2 with valid data updates the user" do
      user = user_fixture()
      assert {:ok, %User{} = user} = Account.update_user(user, @update_attrs)
      assert user.email == "some updated email"
      assert user.nick == "some updated nick"
    end

    test "update_user/2 with invalid data returns error changeset" do
      user = user_fixture()
      assert {:error, %Ecto.Changeset{}} = Account.update_user(user, @invalid_attrs)
      assert user == Account.get_user!(user.id)
    end

    test "delete_user/1 deletes the user" do
      user = user_fixture()
      assert {:ok, %User{}} = Account.delete_user(user)
      assert_raise Ecto.NoResultsError, fn -> Account.get_user!(user.id) end
    end

    test "change_user/1 returns a user changeset" do
      user = user_fixture()
      assert %Ecto.Changeset{} = Account.change_user(user)
    end
  end

  describe "favourites" do
    alias Catcher.Account.Favourite

    @valid_attrs %{comment: "some comment"}
    @update_attrs %{comment: "some updated comment"}
    @invalid_attrs %{comment: nil}

    def favourite_fixture(attrs \\ %{}) do
      {:ok, favourite} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Account.create_favourite()

      favourite
    end

    test "list_favourites/0 returns all favourites" do
      favourite = favourite_fixture()
      assert Account.list_favourites() == [favourite]
    end

    test "get_favourite!/1 returns the favourite with given id" do
      favourite = favourite_fixture()
      assert Account.get_favourite!(favourite.id) == favourite
    end

    test "create_favourite/1 with valid data creates a favourite" do
      assert {:ok, %Favourite{} = favourite} = Account.create_favourite(@valid_attrs)
      assert favourite.comment == "some comment"
    end

    test "create_favourite/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Account.create_favourite(@invalid_attrs)
    end

    test "update_favourite/2 with valid data updates the favourite" do
      favourite = favourite_fixture()
      assert {:ok, %Favourite{} = favourite} = Account.update_favourite(favourite, @update_attrs)
      assert favourite.comment == "some updated comment"
    end

    test "update_favourite/2 with invalid data returns error changeset" do
      favourite = favourite_fixture()
      assert {:error, %Ecto.Changeset{}} = Account.update_favourite(favourite, @invalid_attrs)
      assert favourite == Account.get_favourite!(favourite.id)
    end

    test "delete_favourite/1 deletes the favourite" do
      favourite = favourite_fixture()
      assert {:ok, %Favourite{}} = Account.delete_favourite(favourite)
      assert_raise Ecto.NoResultsError, fn -> Account.get_favourite!(favourite.id) end
    end

    test "change_favourite/1 returns a favourite changeset" do
      favourite = favourite_fixture()
      assert %Ecto.Changeset{} = Account.change_favourite(favourite)
    end
  end
end
