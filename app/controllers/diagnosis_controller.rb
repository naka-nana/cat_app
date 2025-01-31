class DiagnosisController < ApplicationController
  before_action :authenticate_user! # ログイン必須
  before_action :set_user_and_cat, only: [:new, :start, :question, :answer, :result]
  before_action :set_user
  QUESTIONS = YAML.load_file(Rails.root.join('config/questions.yml'))

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
    cat_id = params[:cat_id]
    @cat = @user.cats.find_by(id: cat_id)

    if @cat.nil?
      redirect_to user_select_diagnosis_cat_path(@user), alert: '猫を選択してください'
      return
    end

    # セッションデータの初期化
    session[:selected_cat_id] = @cat.id
    session[:diagnosis_answers] = {}

    # 10問ランダムに選択
    session[:random_questions] = QUESTIONS['questions'].keys.sample(10)
    redirect_to user_cat_question_diagnosis_path(@user, @cat, question_number: 1)
  end

  def question
    @question_number = params[:question_number].to_i
    question_list = session[:random_questions]

    if question_list.nil? || question_list.empty?
      redirect_to user_select_diagnosis_cat_path(@user), alert: '質問リストが初期化されました。もう一度診断を始めてください。'
      return
    end

    if @question_number <= 0 || @question_number > question_list.size
      redirect_to root_path, alert: '不正なアクセスです。'
      return
    end

    question_id = question_list[@question_number - 1]
    @question = QUESTIONS['questions'][question_id]

    return unless @question.nil?

    redirect_to root_path, alert: '質問が見つかりません。'
  end

  def answer
    question_number = params[:question_number].to_i
    answer = params[:answer]

    session[:diagnosis_answers] ||= {}
    session[:diagnosis_answers][question_number] = answer

    next_question_number = question_number + 1
    if next_question_number > session[:random_questions].size
      redirect_to user_cat_result_diagnosis_path(@user, @cat)
    else
      redirect_to user_cat_question_diagnosis_path(@user, @cat, question_number: next_question_number)
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

    result_text = case score
                  when 0..3 then '🥉初心者げぼく'
                  when 4..7 then '🥈中級げぼく'
                  else '🥇上級げぼく'
                  end

    # 診断結果を保存
    @cat.update(diagnosis_result: result_text)

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
