// This file is automatically compiled by Webpack, along with any other files
// present in this directory. You're encouraged to place your actual application logic in
// a relevant structure within app/javascript and only use these pack files to reference
// that code so it'll be compiled.

require("@rails/ujs").start();
require("turbolinks").start();
require("@rails/activestorage").start();
require("channels");

require("@popperjs/core/lib/popper.js");
require('bootstrap-icons/font/bootstrap-icons.css');

import "bootstrap";
import "datatables.net-dt/css/jquery.dataTables.css";
import "../stylesheets/steps.css";
import "../stylesheets/custom_steps.css";
import "@fortawesome/fontawesome-free/css/all";
import "stylesheets/bootstrap-datepicker.css";
import "stylesheets/tempus-dominus.css";
// import 'bootstrap-icons/font/bootstrap-icons.css'

// Import the specific modules you may need (Modal, Alert, etc)
import { Tooltip, Popover } from "bootstrap";

// For ANALYTICS
import "../src/firebase";


// The stylesheet location we created earlier
require("../stylesheets/application.scss");

// If you're using Turbolinks. Otherwise simply use: jQuery(function () {
document.addEventListener("turbolinks:load", (event) => {
  // Both of these are from the Bootstrap 5 docs
  var tooltipTriggerList = [].slice.call(
    document.querySelectorAll('[data-bs-toggle="tooltip"]')
  );
  var tooltipList = tooltipTriggerList.map(function (tooltipTriggerEl) {
    return new Tooltip(tooltipTriggerEl);
  });

  var popoverTriggerList = [].slice.call(
    document.querySelectorAll('[data-bs-toggle="popover"]')
  );
  var popoverList = popoverTriggerList.map(function (popoverTriggerEl) {
    return new Popover(popoverTriggerEl);
  });
});

// const wait = (delay = 0) =>
//   new Promise(resolve => setTimeout(resolve, delay));

// const setVisible = (elementOrSelector, visible) =>
//   (typeof elementOrSelector === 'string'
//     ? document.querySelector(elementOrSelector)
//     : elementOrSelector
//   ).style.display = visible ? 'block' : 'none';

// setVisible('.page', false);
// setVisible('#loading', true);

// document.addEventListener('DOMContentLoaded', () =>
//   wait(1000).then(() => {
//     setVisible('.page', true);
//     setVisible('#loading', false);
//   }));

// Uncomment to copy all static images under ../images to the output folder and reference
// them with the image_pack_tag helper in views (e.g <%= image_pack_tag 'rails.png' %>)
// or the `imagePath` JavaScript helper below.
//
// const images = require.context('../images', true)
// const imagePath = (name) => images(name, true)
