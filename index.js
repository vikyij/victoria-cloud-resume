const counter = document.getElementById("views");
const VisitedBefore = localStorage.getItem("VisitedBefore");

// call lambda function to retrive and update views
async function updateViews() {
  if (VisitedBefore) {
    const response = await fetch(
      "https://4plg5p6rni6hgvxvuxdocg3nbm0icdnq.lambda-url.eu-north-1.on.aws?action=get"
    );
    const data = await response.json();
    counter.textContent = data;
  } else {
    const response = await fetch(
      "https://4plg5p6rni6hgvxvuxdocg3nbm0icdnq.lambda-url.eu-north-1.on.aws?action=increment"
    );
    const data = await response.json();
    counter.textContent = data;
    // mark the user as having visited
    localStorage.setItem("VisitedBefore", true);
  }
}

updateViews();
