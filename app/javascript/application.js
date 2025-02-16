// Configure your import map in config/importmap.rb. Read more: https://github.com/rails/importmap-rails
import "@hotwired/turbo-rails";
import "./comments_dropdown";
import { Application } from "@hotwired/stimulus";
import { eagerLoadControllersFrom } from "@hotwired/stimulus-loading";
import "./comments_dropdown";
// Stimulusアプリケーションを起動
const application = Application.start();

// コントローラーを自動ロード
eagerLoadControllersFrom("controllers", application);

console.log("✅ Stimulus is working!");
