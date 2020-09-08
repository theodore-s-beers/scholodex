<script lang="ts">
  import { onDestroy, onMount } from "svelte";
  import { fade } from "svelte/transition";
  import { cards, expanded, resultCards } from "./stores.svelte";
  import { searchCards } from "./utils.svelte";

  let searchField: HTMLInputElement;
  let searchTerm = "";

  // Function for keydown event in search field
  function handleSearch(event: KeyboardEvent) {
    if (event.key === "Enter") {
      carryOutSearch();
    } else if (event.key === "Escape" || event.key === "Esc") {
      $expanded = false;
    } else {
      return;
    }
  }

  // Function to actually carry out a search
  // Clear prior results
  // Get array of indices from utility function
  // Push cards with those indices into results array
  function carryOutSearch() {
    $resultCards = [];
    const results = searchCards($cards, searchTerm);
    for (let i = 0; i < results.length; i++) {
      const desiredCard = $cards[results[i]];
      $resultCards = $resultCards.concat(desiredCard);
    }
  }

  // Focus on input field on mount
  onMount(() => searchField.focus());

  // Clear results on destroy
  onDestroy(() => ($resultCards = []));
</script>

<style>
  .searchBar {
    width: 100%;
    padding: 0.5rem;
    padding-right: 35px;
    border-radius: 0.25rem;
  }
  .searchBarWrapper {
    margin: 0;
    margin-top: 1rem;
    display: flex;
    flex-flow: row nowrap;
    max-width: 480px;
  }
  .searchButton {
    margin-left: -30px;
    padding: 0;
    padding-top: 2px;
    border: none;
    background: none;
    transform: rotate(-45deg);
    font-size: 125%;
  }
  .searchButton:focus,
  .searchButton:active {
    border: none;
    background: none;
  }
</style>

<div class="searchBarWrapper" in:fade>
  <input
    class="searchBar"
    placeholder="Enter one search term (case-insensitive)"
    bind:this={searchField}
    bind:value={searchTerm}
    on:keydown={handleSearch} /><button
    class="searchButton"
    on:click={carryOutSearch}>⚲</button>
</div>
