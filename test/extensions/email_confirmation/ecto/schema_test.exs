defmodule PowEmailConfirmation.Ecto.SchemaTest do
  use ExUnit.Case
  doctest PowEmailConfirmation.Ecto.Schema

  alias PowEmailConfirmation.Test.Users.User

  test "user_schema/1" do
    user = %User{}

    assert Map.has_key?(user, :email_confirmation_token)
    assert Map.has_key?(user, :email_confirmed_at)
  end

  test "changeset/2 with no email" do
    changeset = User.changeset(%User{}, %{email: "test@example.com"})
    assert Ecto.Changeset.get_change(changeset, :email_confirmation_token)
    refute Ecto.Changeset.get_change(changeset, :email_confirmed_at)
    refute changeset.errors[:email_confirmation_token]
  end

  test "changeset/2 with existing email" do
    user = %User{email: "test@example.com"}

    changeset = User.changeset(user, %{})
    refute Ecto.Changeset.get_change(changeset, :email_confirmation_token)
    refute changeset.errors[:email_confirmation_token]

    changeset = User.changeset(user, %{email: "test@example.com"})
    refute Ecto.Changeset.get_change(changeset, :email_confirmation_token)
    refute changeset.errors[:email_confirmation_token]

    changeset = User.changeset(user, %{email: "new@example.com"})
    assert Ecto.Changeset.get_change(changeset, :email_confirmation_token)
    refute changeset.errors[:email_confirmation_token]
  end
end
