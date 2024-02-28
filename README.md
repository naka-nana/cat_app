# README

# アプリケーション名
ねこの下僕	
# アプリケーション概要	このアプリケーションでできることを記載。
# URL	デプロイ済みのURLを記載。デプロイが済んでいない場合は、デプロイが完了次第記載すること。
# テスト用アカウント	ログイン機能等を実装した場合は、ログインに必要な情報を記載。またBasic認証等を設けている場合は、そのID/Passも記載すること。
# 利用方法	このアプリケーションの利用方法を記載。説明が長い場合は、箇条書きでリスト化すること。
# アプリケーションを作成した背景	このアプリケーションを通じて、どのような人の、どのような課題を解決しようとしているのかを記載。
# 実装した機能についての画像やGIFおよびその説明※	実装した機能について、それぞれどのような特徴があるのかを列挙する形で記載。画像はGyazoで、GIFはGyazoGIFで撮影すること。
# 実装予定の機能	洗い出した要件の中から、今後実装予定の機能がある場合は、その機能を記載。
# データベース設計	ER図を添付。
# 画面遷移図	画面遷移図を添付。
# 開発環境	使用した言語・サービスを記載。
# ローカルでの動作方法	git cloneしてから、ローカルで動作をさせるまでに必要なコマンドを記載。
# 工夫したポイント	制作背景・使用技術・開発方法・タスク管理など、企業へＰＲしたい事柄を記載。
# 改善点	より改善するとしたらどこか、それはどのようにしてやるのか。
# 制作時間	アプリケーションを制作するのにかけた時間。

## Usersテーブル
| Column             | Type	     | Options                      |
| ------------------ | --------- | ---------------------------- |
| userID	           | INTEGER	 | PRIMARY KEY                  |
| email              | string    | null: false, unique: true    |
| last_name          | string    | null: false                  | 
| first_name         | string    | null: false                  | 
| last_name_kana     | string    | null: false                  |
| first_name_kana    | string    | null: false                  |
| nickname           | string    | null: false                  |
| encrypted_password | string    | null: false                  |
| birthday           | date	     | null: false                  |
### association
has_many :cats
has_many :photos
has_many :favorites
has_many :favorite_photos
has_many :followed_users
has_many :following
has_many :relationships

## Cats テーブル
| Column             | Type       |	Options                    |
| ------------------ | ---------- | -------------------------- |
| catID	             | INTEGER    | PRIMARY KEY                |
| ownerUserID	       | INTEGER	  | NOT NULL, FOREIGN KEY (Users) |
| name	             | string     |	NOT NULL                   |
| age_id             | string     |                            |	
| breed              | string     |	                           |
### association
belongs_to :owner
has_many :photos

## Photos Table 
| Column             | Type       |	Options                     |
| ------------------ | ---------- | --------------------------- |
| photoID            | INTEGER    | PRIMARY KEY                 |
| userID             | INTEGER	  | NOT NULL, FOREIGN KEY (Users) |
| catID              | INTEGER    | FOREIGN KEY (Cats)          |
| photoURL	         | TEXT	      | NOT NULL                    |
| description        | TEXT	      |                             |
| sharedWith         | string     |                             |
### association
belongs_to :user
belongs_to :cat
has_many :comments

## Comments テーブル
| Column              | Type       |	Options                    |
| ------------------- | ---------- | --------------------------- |
| commentID	          | INTEGER	   | PRIMARY KEY,                |
| photoID             | INTEGER	   | NOT NULL, FOREIGN KEY (Photos) |
| userID	            | INTEGER	   | NOT NULL, FOREIGN KEY (Users) |
| text	              | TEXT       | NOT NULL                    |
### association
belongs_to :user
belongs_to :photo

## Follows テーブル
| Column              | Type       | Options                     |
| ------------------- | ---------- | --------------------------- |
| followID            | INTEGER    |	PRIMARY KEY                |
| followerUserID      | INTEGER    | NOT NULL, FOREIGN KEY (Users) |
| followedUserID      | INTEGER	   | NOT NULL, FOREIGN KEY (Users) |
### association
belongs_to :follower
belongs_to :followed
has_many :followed_users

## Favorites テーブル
| Column	            | Type       | Options                     |
| ------------------- | ---------- | --------------------------- |
| favoriteID          | INTEGER	   | PRIMARY KEY, AUTOINCREMENT  |
| userID              | INTEGER	   | NOT NULL, FOREIGN KEY (Users) |
| photoID             | INTEGER    | NOT NULL, FOREIGN KEY (Photos) |
### association
belongs_to :user
belongs_to :photo

## Relationships テーブル
| Column              | Type       | Options                     |
| ------------------- | ---------- | --------------------------- |
| relationshipID      | INTEGER    | PRIMARY KEY, AUTOINCREMENT  |
| userID              | INTEGER    | NOT NULL, FOREIGN KEY (Users) |
| catID               | INTEGER    | NOT NULL, FOREIGN KEY (Cats) |
| score               | INTEGER    | 	                          |
| category            | VARCHAR(255) | 	                        |
### association
belongs_to :user
belongs_to :cat

This README would normally document whatever steps are necessary to get the
application up and running.

Things you may want to cover:

* Ruby version

* System dependencies

* Configuration

* Database creation

* Database initialization

* How to run the test suite

* Services (job queues, cache servers, search engines, etc.)

* Deployment instructions

* ...
