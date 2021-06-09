import "index.scss";

// Import all javascript files from src/_components
const componentsContext = require.context("bridgetownComponents", true, /.js$/);
componentsContext.keys().forEach(componentsContext);

import header from "@citizensadvice/design-system/lib/header";
import greedyNav from "@citizensadvice/design-system/lib/greedy-nav/index";
import targetedContent from "@citizensadvice/design-system/lib/targeted-content";

window.addEventListener("load", () => {
  header();
  greedyNav.init();
  targetedContent();
});
