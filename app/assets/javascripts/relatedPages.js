var relatedPages = {
    onLoad:function() {
        //Get current exhibit URL and item id and pass to method
        var relatedPagesDiv = $("#related-pages");
        var exhibitSlug = relatedPagesDiv.attr("exhibitslug");
        var rootUrl = relatedPagesDiv.attr("rooturl");
        var docid = relatedPagesDiv.attr("docid");
        if(exhibitSlug != "" && docid != "" && rootUrl != "") {
          relatedPages.requestPages(rootUrl, exhibitSlug, docid);
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
            var pageList = "";
            var pageTitles = [];
            $.each(pages, function(i, v) {
              if("title" in v) {
                pageTitles.push(v["title"]);
              }
            });
            $("#related-pages").html("This item is used on the following pages: " + pageTitles.join(", "));
          }
        },
        error: function(xhr, status, error) {
          console.log("Error occurred retrieving page list for " + exhibitSlug + " and item " + docid);
          console.log(xhr.status + ":" + xhr.statusText + ":" + xhr.responseText);
        }
      });
    }
};

Blacklight.onLoad(function() {
    if ( $("#related-pages").length > 0) {
      relatedPages.onLoad();
    }
  });