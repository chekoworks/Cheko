
// document.addEventListener("turbolinks:load", function () {
require('datatables.net-dt');

$('#datatable').DataTable({
  "order": [[0, "desc"]],
  destroy:true
});

$('.datatableBasic').DataTable({
  "order": [[0, "desc"]],
  destroy:true
});

$('.homeworks-scrollX').DataTable({
  scrollX: true,
  "order": [[0, "desc"]],
  destroy:true
});

// $('#pending').DataTable({
//   scrollX: true,
//   "order": [[0, "desc"]],
// })

console.log("datatable log")
// });
