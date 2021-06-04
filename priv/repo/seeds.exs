# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     Catcher.Repo.insert!(%Catcher.SomeSchema{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.

Catcher.Repo.insert!(%Catcher.Account.User{email: "damian.tabaka@gmail.com", nick: "tabaka"})
Catcher.Repo.insert!(%Catcher.Account.User{email: "admin.admin@gmail.com", nick: "admin"})
Catcher.Repo.insert!(%Catcher.Account.User{email: "test.test@gmail.com", nick: "test"})
