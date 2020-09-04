<script lang="ts">
  import { fade } from "svelte/transition";
  import {
    cards,
    current,
    editing,
    expanded,
    resultCards,
    selectedItem,
  } from "./stores.svelte";
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

  // Function to load the sample set, if there are no cards
  function loadSample() {
    if ($cards.length === 0) {
      $cards = sampleCards;
    } else {
      return;
    }
  }

  // Run this function on page load
  loadSample();

  // Sort cards by name, in a reactive manner
  $: $cards.sort(complexCompare);

  //
  // Searching
  //

  // Function to toggle the search field
  // When the search field is dismissed, so are results
  function expand() {
    $expanded = !$expanded;
    if (!$expanded) {
      $resultCards = [];
    }
  }

  // Reactive variable for the search term
  // It should be cleared whenever the search field disappears
  $: searchTerm = !$expanded ? "" : "";

  // Function for keydown event in search field
  function handleSearch(event: KeyboardEvent) {
    if (event.key === "Enter") {
      carryOutSearch();
    } else if (event.key === "Escape" || event.key === "Esc") {
      $expanded = false;
      $resultCards = [];
    } else {
      return;
    }
  }

  // Function to actually carry out the search
  // Clear prior results
  // Get array of indices from utility function
  // Push cards with those indices into results array
  function carryOutSearch() {
    $resultCards = [];
    const results = searchCards($cards, searchTerm);
    for (let i = 0; i < results.length; i++) {
      let desiredCard = $cards[results[i]];
      $resultCards.push(desiredCard);
    }
  }

  //
  // Other
  //

  // Function for creating new card
  // Set "current" card to all blank values
  // Switch to editing mode
  // Disable/reset other state items
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
    $expanded = false;
    $resultCards = [];
    $selectedItem = null;
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
    flex-flow: row wrap;
    margin: 0.5em 0 1em 0;
  }
  .cards {
    display: flex;
    flex-flow: row wrap;
    margin-top: -1em;
    margin-left: -1em;
  }
  .expandButton {
    width: 2em;
  }
  .nonFinalButton {
    margin-right: 1em;
  }
  .searchBar {
    width: 334px;
  }
  .searchBarWrapper {
    margin-top: -0.5em;
    margin-bottom: 1em;
  }
  .title {
    font-size: 200%;
    line-height: 105%;
    margin-right: 0.5em;
    color: darkgreen;
  }
  @media (min-width: 768px) {
    .searchBar {
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
  <div class="title">Scholodex</div>
  <div class="nonFinalButton">
    <button on:click={newCard} disabled={$selectedItem || $editing}>New</button>
  </div>
  <div class="nonFinalButton">
    <button
      on:click={loadSample}
      disabled={$cards.length > 0 || $editing}>Sample</button>
  </div>
  <div>
    <button
      class="expandButton"
      disabled={$selectedItem || $editing}
      on:click={expand}>
      {#if $expanded && !$selectedItem && !$editing}
        <span in:fade>▼</span>
      {:else}<span in:fade>◁</span>{/if}
    </button>
  </div>
</header>

{#if $expanded && !$selectedItem && !$editing}
  <div class="searchBarWrapper" in:fade>
    <input
      class="searchBar"
      placeholder="Enter one search term (case-insensitive)"
      bind:value={searchTerm}
      on:keydown={handleSearch} />
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
      {#if $resultCards.length > 0}
        {#each $resultCards as card, index (card.id)}
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
