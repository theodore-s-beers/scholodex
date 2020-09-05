<script lang="ts">
  import { fade } from "svelte/transition";
  import { cards, current, editing, selectedItem } from "./stores.svelte";
  import { complexCompare, sampleCards, searchCards } from "./utils.svelte";

  import Card from "./Card.svelte";
  import Detail from "./Detail.svelte";
  import Editor from "./Editor.svelte";

  //
  // Basic display of cards
  //

  // Try to load cards from local storage
  // Otherwise start with an empty array
  try {
    $cards = JSON.parse(localStorage.getItem("scholodex-cards")) || [];
  } catch (err) {
    $cards = [];
  }

  // Function to load sample set, if no existing cards
  function loadSample() {
    if ($cards.length === 0) {
      $cards = sampleCards;
    }
  }

  // Run this function on page load
  loadSample();

  // Sort cards by name, in a reactive manner
  $: $cards.sort(complexCompare);

  //
  // Search
  //

  // Variable for toggling search field
  let expanded = false;

  // Reactive variable for search results
  // Should be cleared whenever search field disappears
  $: resultCards = !expanded ? [] : [];

  // Reactive variable for search term
  // Should be cleared whenever search field disappears
  $: searchTerm = !expanded ? "" : "";

  // Function for keydown event in search field
  function handleSearch(event: KeyboardEvent) {
    if (event.key === "Enter") {
      carryOutSearch();
    } else if (event.key === "Escape" || event.key === "Esc") {
      expanded = false;
    } else {
      return;
    }
  }

  // Function to actually carry out a search
  // Clear prior results
  // Get array of indices from utility function
  // Push cards with those indices into results array
  function carryOutSearch() {
    resultCards = [];
    const results = searchCards($cards, searchTerm);
    for (let i = 0; i < results.length; i++) {
      const desiredCard = $cards[results[i]];
      resultCards.push(desiredCard);
    }
  }

  //
  // Navigation
  //

  // Listen for hashchange (mainly to select a card)
  window.addEventListener("hashchange", updateView);

  // Function to update view bashed on hash
  function updateView() {
    // Dismiss search field regardless
    expanded = false;
    // For any hash other than "home"
    if (window.location.hash !== "#home") {
      // Try to pull a card with matching ID
      const desiredItem = $cards.find(
        (x) => x.id === window.location.hash.substring(1)
      );
      // If that worked, select that card
      if (desiredItem) {
        $selectedItem = desiredItem;
      } else {
        // Else default to "home"
        window.location.hash = "home";
        $selectedItem = null;
      }
    } else {
      // Null selected item if hash was "home"
      $selectedItem = null;
    }
  }

  // Run this function on page load
  updateView();

  //
  // Other
  //

  // Function for creating new card
  // Set "current" card to all blank values
  // Switch to editing mode
  // Reset other state values
  function newCard() {
    $current = {
      id: "",
      surname: "",
      givenNames: "",
      affiliations: "",
      fields: "",
      email: "",
    };
    $editing = true;
    $selectedItem = null;
    expanded = false;
  }

  // Try to save cards to local storage, in a reactive manner
  $: try {
    localStorage.setItem("scholodex-cards", JSON.stringify($cards));
  } catch (err) {
    // noop
  }
</script>

<style>
  header {
    display: flex;
    flex-flow: row nowrap;
    justify-content: space-between;
    max-width: 334px;
    margin: 0.5em 0 1em 0;
  }
  .cards {
    display: flex;
    flex-flow: row wrap;
    margin-top: -16px;
    margin-left: -16px;
  }
  .expandButton {
    width: 2.3em;
    height: 2.3em;
  }
  .nonFinalButton {
    height: 2.3em;
  }
  .searchBar {
    width: 100%;
    padding-right: 35px;
  }
  .searchBarWrapper {
    margin-top: -0.5em;
    margin-bottom: 1em;
    width: 334px;
    display: flex;
    flex-flow: row nowrap;
  }
  .searchButton {
    margin-left: -30px;
    padding: 0;
    padding-top: 3px;
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
  .title {
    font-size: 200%;
    line-height: 105%;
    margin-right: 0.2em;
    color: darkgreen;
  }
  .title a {
    color: darkgreen;
  }
  .title a:hover {
    text-decoration: none;
  }
  @media (min-width: 768px) {
    .searchBarWrapper {
      width: 687px;
    }
  }
</style>

<svelte:head>
  <meta
    name="description"
    content="A simple address book app, tailored to the needs of academics. Written in Svelte with TypeScript." />
</svelte:head>

<header>
  <div class="title"><a href="/">Scholodex</a></div>
  <div class="nonFinalButtonWrapper">
    <button
      class="nonFinalButton"
      disabled={$selectedItem || $editing}
      on:click={newCard}>New</button>
  </div>
  <div class="nonFinalButtonWrapper">
    <button
      class="nonFinalButton"
      disabled={$cards.length > 0 || $editing}
      on:click={loadSample}>Sample</button>
  </div>
  <div>
    <button
      class="expandButton"
      disabled={$selectedItem || $editing}
      on:click={() => (expanded = !expanded)}>
      {#if expanded}<span in:fade>▼</span>{:else}<span in:fade>▷</span>{/if}
    </button>
  </div>
</header>

{#if expanded}
  <div class="searchBarWrapper" in:fade>
    <input
      class="searchBar"
      placeholder="Enter one search term (case-insensitive)"
      bind:value={searchTerm}
      on:keydown={handleSearch} /><button
      class="searchButton"
      on:click={carryOutSearch}>⚲</button>
  </div>
{/if}

<main>
  {#if $editing}
    <Editor
      surname={$current.surname}
      givenNames={$current.givenNames}
      affiliations={$current.affiliations}
      fields={$current.fields}
      email={$current.email} />
  {:else if $selectedItem}
    <Detail
      index={$cards.indexOf($selectedItem)}
      id={$selectedItem.id}
      surname={$selectedItem.surname}
      givenNames={$selectedItem.givenNames}
      affiliations={$selectedItem.affiliations}
      fields={$selectedItem.fields}
      email={$selectedItem.email} />
  {:else}
    <div class="cards" in:fade>
      {#if resultCards.length > 0}
        {#each resultCards as card, index (card.id)}
          <Card
            {index}
            id={card.id}
            surname={card.surname}
            givenNames={card.givenNames}
            affiliations={card.affiliations}
            fields={card.fields}
            email={card.email} />
        {/each}
      {:else}
        {#each $cards as card, index (card.id)}
          <Card
            {index}
            id={card.id}
            surname={card.surname}
            givenNames={card.givenNames}
            affiliations={card.affiliations}
            fields={card.fields}
            email={card.email} />
        {/each}
      {/if}
    </div>
  {/if}
</main>
