import React from "react";
import { createRoot } from "react-dom/client";
import GlobalSearch from "../components/GlobalSearch";

document.addEventListener("DOMContentLoaded", () => {
  const node = document.getElementById("global-search-root");
  if (node) {
    createRoot(node).render(<GlobalSearch />);
  }
});