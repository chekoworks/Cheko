function autocomplete(inp, arr) {
  /*the autocomplete function takes two arguments,
  the text field element and an array of possible autocompleted values:*/
  var currentFocus;
  /*execute a function when someone writes in the text field:*/
  inp.addEventListener("input", function(e) {
      var a, b, i, val = this.value;
      /*close any already open lists of autocompleted values*/
      closeAllLists();
      if (!val) { return false;}
      console.log(val)
      currentFocus = -1;
      /*create a DIV element that will contain the items (values):*/
      a = document.createElement("DIV");
      a.setAttribute("id", this.id + "autocomplete-list");
      a.setAttribute("class", "autocomplete-items");
      a.setAttribute("style", "color: black !important;");
      /*append the DIV element as a child of the autocomplete container:*/
      this.parentNode.appendChild(a);
      /*for each item in the array...*/
      var empty = true;
      for (i = 0; i < arr.length; i++) {
        if (arr[i][0].toUpperCase().includes(val.toUpperCase())) {
          console.log("found someone")
          b = document.createElement("DIV");
          b.setAttribute("class", "text-start");
          b.innerHTML = arr[i][0].substr(0, val.length)
          b.innerHTML += arr[i][0].substr(val.length);
          
          b.innerHTML += "<input type='hidden' value='" + arr[i][1] + "'>";
          b.addEventListener("click", function(e) {
            window.location.href = window.location.href + "/" + this.getElementsByTagName("input")[0].value
            closeAllLists();
          });
          empty = false
          a.appendChild(b);
        } 
      }
      if(empty){
        console.log("no result")
        b = document.createElement("DIV");
        b.setAttribute("class", "text-start");
        b.innerHTML = "<strong> No Results Found </strong>";
        a.appendChild(b);
      }
  });
  /*execute a function presses a key on the keyboard:*/
  inp.addEventListener("keydown", function(e) {
      var x = document.getElementById(this.id + "autocomplete-list");
      if (x) x = x.getElementsByTagName("div");
      if (e.keyCode == 40) {
        /*If the arrow DOWN key is pressed,
        increase the currentFocus variable:*/
        currentFocus++;
        /*and and make the current item more visible:*/
        addActive(x);
      } else if (e.keyCode == 38) { //up
        /*If the arrow UP key is pressed,
        decrease the currentFocus variable:*/
        currentFocus--;
        /*and and make the current item more visible:*/
        addActive(x);
      } else if (e.keyCode == 13) {
        /*If the ENTER key is pressed, prevent the form from being submitted,*/
        e.preventDefault();
        if (currentFocus > -1) {
          /*and simulate a click on the "active" item:*/
          if (x) x[currentFocus].click();
        }
      }
  });
  function addActive(x) {
    /*a function to classify an item as "active":*/
    if (!x) return false;
    /*start by removing the "active" class on all items:*/
    removeActive(x);
    if (currentFocus >= x.length) currentFocus = 0;
    if (currentFocus < 0) currentFocus = (x.length - 1);
    /*add class "autocomplete-active":*/
    x[currentFocus].classList.add("autocomplete-active");
  }
  function removeActive(x) {
    /*a function to remove the "active" class from all autocomplete items:*/
    for (var i = 0; i < x.length; i++) {
      x[i].classList.remove("autocomplete-active");
    }
  }
  function closeAllLists(elmnt) {
    /*close all autocomplete lists in the document,
    except the one passed as an argument:*/
    var x = document.getElementsByClassName("autocomplete-items");
    for (var i = 0; i < x.length; i++) {
      if (elmnt != x[i] && elmnt != inp) {
      x[i].parentNode.removeChild(x[i]);
    }
  }
}
/*execute a function when someone clicks in the document:*/
document.addEventListener("click", function (e) {
    closeAllLists(e.target);
});
}

var profs
var input 

document.getElementById("myInput").addEventListener("keyup", async function(e) {
  this.input = e.currentTarget.value
  let result = await fetch(`/users/professors/search?search=${e.currentTarget.value}`)
  let data = await result.json()

  autocomplete(document.getElementById("myInput"), data.profs);
});

console.log("test")
// console.log(profs)
// console.log(profs[0][1])
// autocomplete(document.getElementById("myInput"), profs);

// document.getElementById("myInput").addEventListener("input", function(e) {
//   autocomplete(document.getElementById("myInput"), profs);
// })


