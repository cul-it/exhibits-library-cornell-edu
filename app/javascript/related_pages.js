import Blacklight from "blacklight-frontend";

const RelatedPages = {
  onLoad:function() {
    //Get current exhibit URL and item id and pass to method
    var relatedPagesDiv = $("#related-pages");
    var exhibitSlug = relatedPagesDiv.attr("exhibitslug");
    var rootUrl = relatedPagesDiv.attr("rooturl");
    var docid = relatedPagesDiv.attr("docid");
    if(exhibitSlug != "" && docid != "" && rootUrl != "") {
      RelatedPages.requestPages(rootUrl, exhibitSlug, docid);
    }
  },
  requestPages:function(rootUrl, exhibitSlug, docid) {
    //Do an AJAX request for this exhibit
    var url = rootUrl + exhibitSlug + "/itempages?item=" + docid;
    $.ajax({
      url : url,
      success: function(data) {
        console.log(data);
        if((data != null) && ("results" in data) && ("pages" in data["results"]) && (data["results"]["pages"].length > 0)) {
          var pages = data["results"]["pages"];
          var pageTitles = [];
          $.each(pages, function(i, v) {
            pageTitles.push(RelatedPages.generatePageLink(v, rootUrl, exhibitSlug));
          });
          $("#related-pages").html("This item is used on the following pages: " + pageTitles.join(", "));
        }
      },
      error: function(xhr, status, error) {
        console.log("Error occurred retrieving page list for " + exhibitSlug + " and item " + docid);
        console.log(xhr.status + ":" + xhr.statusText + ":" + xhr.responseText);
      }
    });
  },
  generatePageLink(pageObject, rootUrl, exhibitSlug) {
    var title = pageObject["title"];
    var pageSlug = pageObject["slug"];
    var pageType = pageObject["pagetype"];
    var pageURL = rootUrl + exhibitSlug;
    if(pageType == "about") {
      pageURL += "/about/" + pageSlug;
    } else if(pageType == "feature") {
      pageURL += "/feature/" + pageSlug;
    }
    return "<a href='" + pageURL + "'>" + title + "</a>";
  }
};

Blacklight.onLoad(function() {
  if ($("#related-pages").length > 0) {
    RelatedPages.onLoad();
  }
});