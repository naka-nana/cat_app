import { Application } from "@hotwired/stimulus";
import { definitionsFromContext } from "@hotwired/stimulus-loading";
import CommentsDropdownController from "../comments_dropdown";
application.register("comments-dropdown", CommentsDropdownController);

const application = Application.start();
const context = require.context(".", true, /\.js$/);
application.load(definitionsFromContext(context));