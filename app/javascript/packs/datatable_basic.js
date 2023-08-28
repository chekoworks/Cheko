
// document.addEventListener("turbolinks:load", function () {
require('datatables.net-dt');

$('#datatable').DataTable({
  "order": [[0, "desc"]],
});

$('.datatableBasic').DataTable({
  "order": [[0, "desc"]],
});

$('.homeworks-scrollX').DataTable({
  scrollX: true,
  "order": [[0, "desc"]],
});

// $('#pending').DataTable({
//   scrollX: true,
//   "order": [[0, "desc"]],
// })

console.log("datatable log")
// });

