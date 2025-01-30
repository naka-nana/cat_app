class DiagnosisController < ApplicationController
  before_action :authenticate_user! # ログイン必須
  before_action :set_user_and_cat, only: [:new, :start, :question, :answer, :result]
  before_action :set_user

  QUESTIONS = {
    1 => '猫ちゃんは夜眠るとき、あなたの近くで寝ていますか？',
    2 => '猫ちゃんはあなたにグルーミング（舐めてくる行為）をしますか？',
    3 => '猫ちゃんはあなたの近くでお腹を見せて寝たり、くつろいだりしますか？',
    4 => '猫ちゃんがあなたに近づくとき、しっぽをピン！と立てていますか？',
    5 => '猫ちゃんはあなたに「スリスリ」をしますか？',
    6 => '猫ちゃんはあなたに「鼻チュー」をしますか？',
    7 => '猫ちゃんは撫でるとゴロゴロ喉を鳴らしますか？',
    8 => '猫ちゃんはあなたが目を見つめると、ゆっくりと瞬きしますか？',
    9 => '猫ちゃんは「モミモミ」、「フミフミ」を見せてきますか？',
    10 => '猫ちゃんはあなたと接しているときヒゲが10時10分の方向を向いていますか？',
    11 => '猫ちゃんはあなたが帰宅すると出迎えに来ますか？',
    12 => '猫ちゃんはあなたの膝の上で寝ますか？',
    13 => '猫ちゃんはあなたの指や顔を舐めてきますか？',
    14 => '猫ちゃんはあなたの手を甘噛みしますか？',
    15 => '猫ちゃんはあなたの声に反応して鳴きますか？'
  }

  def new
    @user = User.find(params[:user_id])
    @cat = @user.cats.find(params[:id]) # ここが正しく取得できているか確認
    @questions = QUESTIONS
  end

  def select_cat
    @cats = @user.cats
  end

  def start
    @user = User.find(params[:user_id])
    Rails.logger.debug "Received params: #{params.inspect}"
    cat_id = params[:cat_id]
    @cat = @user.cats.find_by(id: cat_id)

    if @cat.nil?
      redirect_to user_select_diagnosis_cat_path(@user), alert: '猫を選択してください'
      return
    end

    session[:selected_cat_id] = @cat.id
    session[:diagnosis_answers] = {}

    # 10問確実に選ぶように変更
    question_keys = QUESTIONS.keys.shuffle.take(10)
    session[:random_questions] = question_keys

    Rails.logger.debug "選ばれた質問リスト: #{question_keys}"

    redirect_to user_cat_question_diagnosis_path(@user, @cat, question_number: 1)
  end

  def question
    @question_number = params[:question_number].to_i

    # 🔹 ここでセッションからリストを必ず使う
    question_list = session[:random_questions] || QUESTIONS.keys.sample(10).uniq
    if session[:random_questions].nil?
      question_list = QUESTIONS.keys.sample(10).uniq
      question_list += (QUESTIONS.keys - question_list).sample(10 - question_list.size) while question_list.size < 10
      session[:random_questions] = question_list
    end
    # セッションが初期化されていなければエラーハンドリング
    if question_list.nil? || question_list.empty?
      redirect_to user_select_diagnosis_cat_path(@user), alert: '質問リストが初期化されました。もう一度診断を始めてください。'
      return
    end

    @question_id = question_list[@question_number - 1] # 🔹 リストから取得
    Rails.logger.debug "現在の質問番号: #{@question_number}, 質問ID: #{@question_id}"
    @question = QUESTIONS[@question_id]

    # 質問が存在しない場合は結果へ
    return unless @question.nil?

    redirect_to user_cat_result_diagnosis_path(@user, @cat) and return
  end

  def answer
    question_number = params[:question_number].to_i
    answer = params[:answer].to_i

    # セッションに回答を保存
    session[:diagnosis_answers] ||= {}
    session[:diagnosis_answers][question_number] = answer

    # 次の質問に進む
    next_question_number = question_number + 1

    if next_question_number > 10
      # 10問すべて回答したら結果ページへ
      redirect_to user_cat_result_diagnosis_path(@user, @cat) and return
    else
      # 次の質問へ進む
      redirect_to user_cat_question_diagnosis_path(@user, @cat, question_number: next_question_number) and return
    end
  end

  def result
    redirect_to user_select_diagnosis_cat_path(@user), alert: '診断した猫が見つかりません。' and return if session[:selected_cat_id].nil?

    @cat = Cat.find_by(id: session[:selected_cat_id])
    redirect_to user_select_diagnosis_cat_path(@user), alert: '診断した猫が見つかりません。' and return if @cat.nil?

    @answers = session[:diagnosis_answers] || {}

    if @answers.empty?
      redirect_to user_cat_question_diagnosis_path(@user, @cat, question_number: 1), alert: '診断が未完了です。' and return
    end

    score = @answers.values.map(&:to_i).sum

    @result = case score
              when 0..3 then '初心者げぼく'
              when 4..7 then '中級げぼく'
              else '上級げぼく！猫ちゃんもあなたを信頼しています！'
              end

    session.delete(:random_questions)
    session.delete(:diagnosis_answers)
  end

  private

  def set_user
    @user = User.find(params[:user_id])
  end

  def set_user_and_cat
    @user = User.find(params[:user_id])
    @cats = @user.cats # ← これを追加！
    if params[:cat_id].present?
      @cat = Cat.find_by(id: params[:cat_id], user_id: @user.id)
      redirect_to user_select_diagnosis_cat_path(@user), alert: '猫を選択してください。' if @cat.nil?
    else
      redirect_to user_select_diagnosis_cat_path(@user), alert: '猫を選択してください。'
    end
  end
end
