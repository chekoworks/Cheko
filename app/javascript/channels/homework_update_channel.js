
import $ from 'jquery';
import DataTable from 'datatables.net-dt';
require('datatables.net-dt');
import consumer from "./consumer"

document.addEventListener('turbolinks:load', () => {

  if (window.location.pathname == "/managers/homeworks" || window.location.pathname == "/admins/homeworks") {
    console.log("IS HERE");
    const adminTablePending = $('#admin-homework-table #pending').DataTable({
      scrollX: true,
      order: [[0, 'desc']],
      paging: false,
      searching: false,
      destroy:true
    });

    const adminTableOngoing = $("#admin-homework-table #ongoing").DataTable({
      scrollX: true,
      order: [[0, 'desc']],
      paging: false,
      searching: false,
      destroy:true
    });

    const adminTableForApproval = $("#admin-homework-table #forApproval").DataTable({
      scrollX: true,
      order: [[0, 'desc']],
      paging: false,
      searching: false,
      destroy:true
    });

    const adminTableHistory = $("#admin-homework-table #history").DataTable({
      scrollX: true,
      order: [[0, 'desc']],
      paging: false,
      searching: false,
      destroy:true
    });

    const managerTablePending = $('#manager-homework-table #pending').DataTable({
      scrollX: true,
      order: [[0, 'desc']],
      paging: false,
      searching: false,
      destroy:true
    });

    const managerTableOngoing = $("#manager-homework-table #ongoing").DataTable({
      scrollX: true,
      order: [[0, 'desc']],
      paging: false,
      searching: false,
      destroy:true
    });

    const managerTableForApproval = $("#manager-homework-table #forApproval").DataTable({
      scrollX: true,
      order: [[0, 'desc']],
      paging: false,
      searching: false,
      destroy:true
    });

    const managerTableHistory = $("#manager-homework-table #history").DataTable({
      scrollX: true,
      order: [[0, 'desc']],
      paging: false,
      searching: false,
      destroy:true
    });


    consumer.subscriptions.create("HomeworkUpdateChannel", {
      connected() {
        // Called when the subscription is ready for use on the server
      },

      disconnected() {
        // Called when the subscription has been terminated by the server
      },

      received(data) {
        // Called when there's incoming data on the websocket for this channel
        console.log("HOMEWORK UPDATE CHANNEL >>> ");
        console.log(data);

        var fromControllerAction = data.controller_action
        var homework = data.data.homework

        console.log(homework);

        if (fromControllerAction == "create") {
          if (document.getElementById('admin-homework-table')) {

            var currentAdminID = $("#admin-homework-table").data("admin-id");
            var currentAdminRole = $("#admin-homework-table").data("admin-role");

            var actionStr = '<a href="/admins/homeworks/' + homework.id + '"><div class="fas fa-eye text-primary font-16 mr-3"></div></a>';

            if (homework.admin_id == currentAdminID || currentAdminRole == 'super_admin') {
              actionStr += '<a href="/admins/homeworks/' + homework.id + '/edit"><div class="fas fa-pen text-secondary font-16 mr-3"></div></a><a data-method="put" href="/admins/homeworks/' + homework.id + '/assign"><div class="fas fa-circle-check text-success font-16 mr-3"></div></a>';
            } else if (homework.admin_id == null) {
              actionStr += '<a data-method="put" href="/admins/homeworks/' + homework.id + '/assign"><div class="fas fa-circle-check text-success font-16 mr-3"></div></a>';
            }

            adminTablePending.row.add([
              homework.id,
              homework.created_at,
              homework.order_type,
              homework.sub_type,
              homework.deadline,
              homework.subject,
              homework.tutor_category,
              homework.words,
              homework.tutor_samples,
              homework.tutor_skills,
              homework.view_bidders,
              homework.priority,
              homework.login_school,
              homework.admin,
              actionStr,
            ]).draw(true);
          } else if (document.getElementById('manager-homework-table')) {

            managerTablePending.row.add([
              homework.id,
              homework.name,
              homework.created_at,
              homework.order_type,
              homework.sub_type,
              homework.internal_deadline_date,
              homework.subject,
              homework.details,
              homework.tutor_category,
              homework.words,
              homework.priority,
              homework.login_school,
              homework.user,
              homework.tutor,
              homework.sub_tutor,
              homework.hours_late,
              homework.prof,
              homework.grade,
              homework.status,
              '<a href="/admins/homeworks/' + homework.id + '"><div class="fas fa-eye text-success font-16-mr-3"></div></a><a href="/admins/homeworks/' + homework.id + '/edit"><div class="fas fa-pen text-primary font-16 mr-3"></div></a>']).draw(true);
          }
        }
        else if (fromControllerAction == "update") {
          console.log("UPDATE ACTION");
          if (document.getElementById('admin-homework-table')) {
            console.log("ADMIN TABLE");

            var currentAdminID = $("#admin-homework-table").data("admin-id");
            var currentAdminRole = $("#admin-homework-table").data("admin-role");

            var actionStr = '<a href="/admins/homeworks/' + homework.id + '"><div class="fas fa-eye text-success font-16 mr-3"></div></a>';

            if (homework.admin_id == currentAdminID || currentAdminRole == 'super_admin') {
              actionStr += '<a href="/admins/homeworks/' + homework.id + '/edit"><div class="fas fa-pen text-primary font-16 mr-3"></div></a><a data-method="put" href="/admins/homeworks/' + homework.id + '"><div class="fas fa-trash text-danger font-16 mr-3"></div></a>';
            } else if (homework.admin_id == null) {
              actionStr += '<a data-method="put" href="/admins/homeworks/' + homework.id + '/assign"><div class="fas fa-trash text-danger font-16 mr-3"></div></a>';
            }
            console.log(adminTablePending.row({ id: homework.id }).data());

            if (adminTablePending.row({ id: homework.id }).length > 0) {
              adminTablePending.row({ id: homework.id }).remove().draw(true);
            }

            if (adminTableOngoing.row({ id: homework.id }).length > 0) {
              adminTableOngoing.row({ id: homework.id }).remove().draw(true);
            }

            adminTableOngoing.row.add([
              homework.id,
              homework.user,
              homework.tutor_category,
              homework.tutor,
              homework.sub_tutor,
              homework.admin,
              homework.manager,
              homework.tutor_price,
              homework.price,
              homework.profit,
              homework.tutor_skills,
              homework.tutor_samples,
              homework.view_bidders,
              homework.priority,
              homework.login_school,
              homework.order_type,
              homework.sub_type,
              homework.updates,
              homework.deadline.toString().split(" - ")[0],
              homework.deadline.toString().split(" - ")[1],
              homework.internal_deadline_date,
              homework.internal_deadline_time,
              homework.subject,
              homework.sub_subject,
              homework.file_received,
              homework.hours_late,
              homework.notes,
              homework.prof,
              homework.course,
              homework.grade,
              homework.status,
              "",
              "",
              homework.payment_received == null ? "" : homework.payment_received,
              actionStr,
            ]).draw(true);

          } else if (document.getElementById('manager-homework-table')) {
            console.log("MANAGER TABLE");

            console.log(managerTablePending.row({ id: homework.id }).data());
            if (managerTablePending.row({ id: homework.id }).length > 0) {
              managerTablePending.row({ id: homework.id }).remove().draw(true);
            }

            if (managerTableOngoing.row({ id: homework.id }).length > 0) {
              managerTableOngoing.row({ id: homework.id }).remove().draw(true);
            }

            managerTableOngoing.row.add([
              homework.id,
              homework.name,
              homework.created_at,
              homework.order_type,
              homework.sub_type,
              homework.internal_deadline_date,
              homework.subject,
              homework.details,
              homework.tutor_category,
              homework.words,
              homework.priority,
              homework.login_school,
              homework.user,
              homework.tutor,
              homework.sub_tutor,
              homework.hours_late,
              homework.prof,
              homework.grade,
              homework.status,
              '<a href="/admins/homeworks/' + homework.id + '"><div class="fas fa-eye text-success font-16-mr-3"></div></a><a href="/admins/homeworks/' + homework.id + '/edit"><div class="fas fa-pen text-primary font-16 mr-3"></div></a>']).draw(true);
          }
        }
        else if (fromControllerAction == "tutor_finish_homework") {
          if (document.getElementById('admin-homework-table')) {
            var actionStr = '<a href="/admins/homeworks/' + homework.id + '"><div class="fas fa-eye text-success font-16 mr-3"></div></a>';

            if (adminTableOngoing.row({ id: homework.id }).length > 0) {
              adminTableOngoing.row({ id: homework.id }).remove().draw(true);
            }

            adminTableForApproval.row.add([
              homework.id,
              homework.user,
              homework.tutor_category,
              homework.tutor,
              homework.sub_tutor,
              homework.admin,
              homework.manager,
              homework.tutor_price,
              homework.price,
              homework.profit,
              homework.tutor_skills,
              homework.tutor_samples,
              homework.view_bidders,
              homework.priority,
              homework.login_school,
              homework.order_type,
              homework.sub_type,
              homework.updates,
              homework.deadline.toString().split(" - ")[0],
              homework.deadline.toString().split(" - ")[1],
              homework.internal_deadline_date,
              homework.internal_deadline_time,
              homework.subject,
              homework.sub_subject,
              homework.file_received,
              homework.hours_late,
              homework.notes,
              homework.prof,
              homework.course,
              homework.grade,
              homework.status,
              "",
              "",
              homework.payment_received == null ? "" : homework.payment_received,
              actionStr,
            ]).draw(true);

          } else if (document.getElementById('manager-homework-table')) {

            if (managerTableOngoing.row({ id: homework.id }).length > 0) {
              managerTableOngoing.row({ id: homework.id }).remove().draw(true);
            }

            managerTableForApproval.row.add([
              homework.id,
              homework.name,
              homework.created_at,
              homework.order_type,
              homework.sub_type,
              homework.internal_deadline_date,
              homework.subject,
              homework.details,
              homework.tutor_category,
              homework.words,
              homework.priority,
              homework.login_school,
              homework.user,
              homework.tutor,
              homework.sub_tutor,
              homework.hours_late,
              homework.prof,
              homework.grade,
              homework.status,
              '<a href="/admins/homeworks/' + homework.id + '"><div class="fas fa-eye text-success font-16-mr-3"></div></a>']).draw(true);
          }
        }
        else if (fromControllerAction == "finish_homework") {
          if (document.getElementById('admin-homework-table')) {
            var actionStr = '<a href="/admins/homeworks/' + homework.id + '"><div class="fas fa-eye text-success font-16 mr-3"></div></a>';

            if (adminTableForApproval.row({ id: homework.id }).length > 0) {
              adminTableForApproval.row({ id: homework.id }).remove().draw(true);
            }

            adminTableHistory.row.add([
              homework.id,
              homework.user,
              homework.tutor_category,
              homework.tutor,
              homework.sub_tutor,
              homework.admin,
              homework.manager,
              homework.tutor_price,
              homework.price,
              homework.profit,
              homework.tutor_skills,
              homework.tutor_samples,
              homework.view_bidders,
              homework.priority,
              homework.login_school,
              homework.order_type,
              homework.sub_type,
              homework.updates,
              homework.deadline.toString().split(" - ")[0],
              homework.deadline.toString().split(" - ")[1],
              homework.internal_deadline_date,
              homework.internal_deadline_time,
              homework.subject,
              homework.sub_subject,
              homework.file_received,
              homework.hours_late,
              homework.notes,
              homework.prof,
              homework.course,
              homework.grade,
              homework.status,
              "",
              "",
              homework.payment_received == null ? "" : homework.payment_received,
              actionStr,
            ]).draw(true);

          } else if (document.getElementById('manager-homework-table')) {

            if (managerTableForApproval.row({ id: homework.id }).length > 0) {
              managerTableForApproval.row({ id: homework.id }).remove().draw(true);
            }

            managerTableHistory.row.add([
              homework.id,
              homework.name,
              homework.created_at,
              homework.order_type,
              homework.sub_type,
              homework.internal_deadline_date,
              homework.subject,
              homework.details,
              homework.tutor_category,
              homework.words,
              homework.priority,
              homework.login_school,
              homework.user,
              homework.tutor,
              homework.sub_tutor,
              homework.hours_late,
              homework.prof,
              homework.grade,
              homework.status,
              '<a href="/admins/homeworks/' + homework.id + '"><div class="fas fa-eye text-success font-16-mr-3"></div></a>']).draw(true);
          }
        }

      }
    });
  }

});
