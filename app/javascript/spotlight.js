import Blacklight from "blacklight-frontend";
import Spotlight from "spotlight-frontend"

Blacklight.onLoad(function() {
  Spotlight.activate();
});
