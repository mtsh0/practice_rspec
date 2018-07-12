require 'rails_helper'

RSpec.describe Note, type: :model do

  # このファイルの全テストで使用するテストデータをセットアップする
  # ただし "search message for a term" 内には適用されない(describeを利用しているから)
  before do
    @user = User.create(
      first_name: "Joe",
      last_name: "Tester",
      email: "joetester@example.com",
      password: "dottle-nouveau-pavilion-tights-furze",
      )

    @project = @user.projects.create(
        name: "Test Project",
      )
  end

  # ユーザー、プロジェクト、メッセージがあれば有効な状態であること
  it "is valid with a user, project, and message" do
    note = Note.new(
      message: "This is a sample note.",
      user: @user,
      project: @project,
      )
    expect(note).to be_valid
  end

  # メッセージがなければ無効であること
  it "is invalid without a message" do
    note = Note.new(message: nil)
    note.valid?
    expect(note.errors[:message]).to include("can't be blank")
  end


  # 文字列に一致するメッセージを検索する
  describe "search message for a term" do

    before do
      # 検索機能の全テストに関連する追加のテストデータをセットアップする
      @note1 = @project.notes.create(
          message: "This is the first note.",
          user: @user,
        )

      @note2 = @project.notes.create(
          message: "This is the second note.",
          user: @user,
        )

      @note3 = @project.notes.create(
          message: "First, preheat the oven.",
          user: @user,
        )
    end


    # 一致するデータが見つかる時
    context "when a match is found" do

      # 検索文字列に一致するメモを返すこと
      it "returns notes that match the search term" do

        # Noteモデルを"first"で検索した時、note1,note3がmatchすることを期待する
        expect(Note.search("first")).to include(@note1, @note3)

        # Noteモデルを"first"で検索した時、note2がmatchしないことを期待する
        expect(Note.search("first")).to_not include(@note2)

        # Noteモデルを"message"で検索した時、検索結果がないことを期待する
        expect(Note.search("message")).to be_empty

      end
    end

    # 一致するデータが1件も見つからないとき
    context "when no match is found" do

      # 空のコレクションを返すこと
      it "returns notes that match the search term" do

        # Noteモデルを"message"で検索した時、検索結果がないことを期待する
        expect(Note.search("message")).to be_empty
      end
    end
  end
end
