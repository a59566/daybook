// This file is automatically compiled by Webpack, along with any other files
// present in this directory. You're encouraged to place your actual application logic in
// a relevant structure within app/javascript and only use these pack files to reference
// that code so it'll be compiled.

require("@rails/ujs").start();
require("turbolinks").start();
require("@rails/activestorage").start();
require("channels");
require("chartkick");
require("chart.js");
require("bootstrap");
require("../src/application.scss");

// Uncomment to copy all static images under ../images to the output folder and reference
// them with the image_pack_tag helper in views (e.g <%= image_pack_tag 'rails.png' %>)
// or the `imagePath` JavaScript helper below.
//
// const images = require.context('../images', true)
// const imagePath = (name) => images(name, true)


// delete table row when destroy action succeed
document.addEventListener('turbolinks:load', function () {
    document.querySelectorAll('.delete').forEach(function (a) {
        a.addEventListener('ajax:success', function () {
            const tr = a.parentNode.parentNode;
            tr.style.display = 'none';
        })
    });

    document.querySelectorAll('form[data-remote="true"]').forEach(function (form) {
        form.addEventListener('ajax:error', function (event) {
            //clear error
            form.querySelectorAll('.is-invalid').forEach(function (invalid_node) {
               invalid_node.classList.remove('is-invalid')
            });
            form.querySelectorAll('.invalid-feedback').forEach(function (feedback_node) {
                feedback_node.remove();
            });

            const errors = JSON.parse(event.detail[2].responseText);
            form.querySelectorAll('.form-control').forEach(function (form_control) {

                const error_message = errors[`${form_control.id}`];
                if (error_message !== undefined) {
                    form_control.classList.add('is-invalid');
                    form_control.insertAdjacentHTML('afterend',
                        `<div class="invalid-feedback">${error_message}</div>`);
                }
            })
        })
    });
});



