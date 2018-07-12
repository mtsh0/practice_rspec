require 'rails_helper'

RSpec.describe Note, type: :model do
  it "returns notes that match the search term" do
    user = User.create(
      first_name: "Joe",
      last_name: "Tester",
      email: "joetester@example.com",
      password: "dottle-nouveau-pavilion-tights-furze",
      )

    project = user.projects.create(
        name: "Test Project",
      )

    note1 = project.notes.create(
        message: "This is the first note.",
        user: user,
      )

    note2 = project.notes.create(
        message: "This is the second note.",
        user: user,
      )

    note3 = project.notes.create(
        message: "First, preheat the oven.",
        user: user,
      )

    # Noteモデルを"first"で検索した時、note1,note3がmatchすることを期待する
    expect(Note.search("first")).to include(note1, note3)
    # Noteモデルを"first"で検索した時、note2がmatchしないことを期待する
    expect(Note.search("first")).to_not include(note2)
    # Noteモデルを"message"で検索した時、検索結果がないことを期待する
    expect(Note.search("message")).to be_empty

  end
end
