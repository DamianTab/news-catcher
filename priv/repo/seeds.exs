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


Catcher.Repo.insert!(%Catcher.News.Article{
  summary: "New SIG Advisory Board members will serve three-year terms and help guide the strategic direction of SIG.JACKSONVILLE, Fla., April 23, 2020 /PRNewswire-PRWeb/ -- Sourcing Industry Group (SIG), the premier membership organization for sourcing, procurement, outsourcing and risk executives, today announces the appointment of eight senior executives to the SIG Advisory Board for a three-year term, including: Jeff Amsel, Vice President, Global Sourcing and Real Estate, HERE TechnologiesTony Filippone, Chief Procurement Officer, Axis CapitalDaryl Hammett, Chief Operating Officer, ConnXusPat McCarthy, Senior Vice President and General Manager, Global, SAP Ariba and SAP FieldglassMike Morsch, Vice President, Global Procurement and Supply Chain, CDK GlobalChris Sawchuk, Principal and Global Procurement Advisory Practice Leader, The Hackett GroupMichael van Keulen, Chief Procurement Officer, CoupaMichele Wesseling, Associate Vice President, Global Third Party Management Office, TD Securities Limited \"We are thrilled to have such an outstanding advisory board,\" said Dawn Tiura, President and CEO of SIG.",
  country: "US",
  author: "null",
  link: "https://finance.yahoo.com/news/sourcing-industry-group-names-executives-110000637.html",
  language: "en",
  media: "https://s.yimg.com/cv/apiv2/social/images/yahoo_default_logo-1200x1200.png",
  title: "Sourcing Industry Group Names Executives from Axis Capital, Coupa and SAP Ariba to Advisory Board",
  rights: "yahoo.com",
  topic: "finance",
  published_date: ~N[2020-04-23 07:00:00]
})

Catcher.Repo.insert!(%Catcher.News.Article{
  summary: "Summary",
  country: "PL",
  author: "Damian T",
  link: "https://finance.yahoo.com/news/sourcing-industry-group-names-executives-110000637.html",
  language: "pl",
  media: "https://s.yimg.com/cv/apiv2/social/images/yahoo_default_logo-1200x1200.png",
  title: "Wymyślny temat nagłówka !",
  rights: "google.pl",
  topic: "politics",
  published_date: ~N[2019-04-23 10:20:00]
})

Catcher.Repo.insert!(%Catcher.Account.Favourite{
  user_id: 1,
  article_id: 1,
  comment: "Fajny artykuł"
})

Catcher.Repo.insert!(%Catcher.Account.Favourite{
  user_id: 2,
  article_id: 2,
  comment: "Nie fajny artykuł"
})
