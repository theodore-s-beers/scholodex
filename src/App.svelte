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
  import { complexCompare, sampleCards } from "./utils.svelte";

  import Card from "./Card.svelte";
  import Detail from "./Detail.svelte";
  import Editor from "./Editor.svelte";
  import Search from "./Search.svelte";

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
  // Navigation
  //

  // Listen for hashchange (mainly to select a card)
  window.addEventListener("hashchange", updateView);

  // Function to update view based on hash
  function updateView() {
    // Start by resetting default values
    $expanded = false;
    $selectedItem = null;
    // For any hash other than "home"
    if (window.location.hash && window.location.hash !== "#home") {
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
      }
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
    $expanded = false;
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
      on:click={() => ($expanded = !$expanded)}>
      {#if $expanded}<span in:fade>▼</span>{:else}<span in:fade>▷</span>{/if}
    </button>
  </div>
</header>

{#if $expanded}
  <Search />
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
