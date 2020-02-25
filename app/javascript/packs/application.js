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
require("data-confirm-modal");
require("../src/application.scss");
import Sortable from 'sortablejs';

// Uncomment to copy all static images under ../images to the output folder and reference
// them with the image_pack_tag helper in views (e.g <%= image_pack_tag 'rails.png' %>)
// or the `imagePath` JavaScript helper below.
//
// const images = require.context('../images', true)
// const imagePath = (name) => images(name, true)

dataConfirmModal.setDefaults({
    title: '提醒',
    commit: '確認',
    cancel: '取消',
    cancelClass: 'btn-secondary'
});

document.addEventListener('turbolinks:load', function () {
    // guest welcome message
    $('#guest_notice')?.modal('show');

    // http 401 error handle
    document.body.addEventListener('ajax:error', function (event) {
        if (event.detail[2].status === 401) {
            dataConfirmModal.confirm({
                text: event.detail[2].responseText,
                cancelClass : 'd-none',
                onConfirm: function() { location.href = '/users/sign_in' }
            });
        }
    });

    // delete table row when destroy action succeed
    document.querySelectorAll('.delete').forEach(function (a) {
        a.addEventListener('ajax:success', function () {
            const tr = a.parentNode.parentNode;
            tr.style.display = 'none';
        })
    });

    // add validation error info for remote form
    document.querySelectorAll('form[data-remote="true"]').forEach(function (form) {
        form.addEventListener('ajax:error', function (event) {
            if(event.detail[2].status === 422) {
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
            }
        })
    });

    //sortable tags
    const tags = document.getElementById('tags');
    if(tags) {
        Sortable.create(tags, {
            onChoose: function (event) {
                event.item.classList.remove('grab');
                event.item.classList.add('grabbing');
            },
            onUnchoose: function(event) {
                event.item.classList.remove('grabbing');
                event.item.classList.add('grab');
            },
            onUpdate: function(event) {
                let params = {};
                params[event.item.dataset.modelName] =
                    {display_order_position: event.newIndex};
                $.ajax({
                    type: 'PATCH',
                    url: event.item.dataset.updateUrl,
                    data: params
                });
            }
        });
    }
});



