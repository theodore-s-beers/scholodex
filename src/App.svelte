<script lang="ts">
  import { fade } from "svelte/transition";
  import {
    about,
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
  import Welcome from "./Welcome.svelte";

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
    } else {
      window.location.hash = "home";
    }
  }

  // Sort cards by name, in a reactive manner
  $: $cards.sort(complexCompare);

  //
  // Navigation
  //

  // Listen for hashchange
  window.addEventListener("hashchange", updateView);

  // Function to update view based on hash
  function updateView() {
    // Start by resetting default values
    $about = false;
    $editing = false;
    $expanded = false;
    $selectedItem = null;

    // If no hash, set to "home"
    if (!window.location.hash) {
      window.location.hash = "home";
    } else if (window.location.hash === "#about") {
      // If "#about" show project description
      $about = true;
    } else if (window.location.hash === "#home") {
      // If "#home" check for absence of cards
      if ($cards.length === 0) {
        window.location.hash = "about";
      } else {
        // Otherwise return
        return;
      }
    } else if (window.location.hash === "#new") {
      // If "#new" switch to editing mode
      $editing = true;
    } else if (window.location.hash === "#sample") {
      // If "#sample" run the appropriate function
      loadSample();
    } else {
      // This suggests a UUID hash
      // Try to pull a card with matching ID
      const desiredItem = $cards.find(
        (x) => x.id === window.location.hash.substring(1)
      );
      // If it worked, select that card
      if (desiredItem) {
        $selectedItem = desiredItem;
      } else {
        // Otherwise fall back to "home"
        window.location.hash = "home";
      }
    }
  }

  // Run this function on page load
  updateView();

  // Function to open and close project description
  function toggleAbout() {
    if (!$about) {
      window.location.hash = "about";
    } else {
      window.location.hash = "home";
    }
  }

  // Keep "listening" for absence of cards
  $: if ($cards.length === 0) {
    window.location.hash = "about";
  }

  //
  // Other
  //

  // Function for creating new card
  // Set "current" card to all blank values
  // Set hash "new"
  function newCard() {
    $current = {
      id: "",
      surname: "",
      givenNames: "",
      affiliations: "",
      fields: "",
      ideas: "",
      email: "",
    };
    window.location.hash = "new";
  }

  // Try to save cards to local storage, in a reactive manner
  $: try {
    localStorage.setItem("scholodex-cards", JSON.stringify($cards));
  } catch (err) {
    // noop
  }
</script>

<style>
  button {
    height: 2.4rem;
    width: 2.4rem;
    margin-right: 1rem;
  }
  header {
    background-color: #fafafa;
    border: 1px solid rgba(16, 112, 64, 0.4);
    border-radius: 0.25rem;
    margin: 0;
    margin-bottom: 1rem;
    padding: 1rem;
  }
  .cards {
    display: flex;
    flex-flow: row wrap;
    margin-top: -1rem;
    margin-left: -1rem;
  }
  .container {
    max-width: 334px;
    margin: auto;
    padding: 1.5rem 1rem 2rem 1rem;
  }
  .infoButton {
    padding-bottom: 1rem;
    font-size: 120%;
    margin-right: 0;
  }
  .newButton {
    padding-bottom: 4px;
    font-size: 130%;
  }
  .searchButton {
    font-size: 115%;
  }
  .title {
    font-size: 200%;
    line-height: 105%;
    margin-right: auto;
    color: #0c6e3d;
  }
  .title a {
    color: #0c6e3d;
  }
  .title a:hover {
    text-decoration: none;
  }
  .titleRow {
    display: flex;
    flex-flow: row nowrap;
  }
  @media (min-width: 768px) {
    .container {
      max-width: 684px;
    }
    .title {
      margin-right: 1.5rem;
    }
  }
  @media (min-width: 1280px) {
    .container {
      max-width: 1034px;
    }
  }
  @media (min-width: 1440px) {
    .container {
      max-width: 1384px;
    }
  }
</style>

<div class="container">
  <header>
    <div class="titleRow">
      <div class="title"><a href="/"><em>Scholodex</em></a></div>
      <div>
        <button
          class="newButton"
          disabled={$editing || $selectedItem}
          on:click={newCard}>+</button>
      </div>
      <div>
        <button
          class="searchButton"
          disabled={$about || $editing || $selectedItem}
          on:click={() => ($expanded = !$expanded)}>?</button>
      </div>
      <div>
        <button
          class="infoButton"
          disabled={$cards.length === 0 || $editing || $selectedItem}
          on:click={toggleAbout}>…</button>
      </div>
    </div>

    {#if $expanded}
      <Search />
    {/if}
  </header>

  {#if $about}
    <Welcome />
  {:else if $editing}
    <Editor
      surname={$current.surname}
      givenNames={$current.givenNames}
      affiliations={$current.affiliations}
      fields={$current.fields}
      ideas={$current.ideas}
      email={$current.email} />
  {:else if $selectedItem}
    <Detail
      index={$cards.indexOf($selectedItem)}
      id={$selectedItem.id}
      surname={$selectedItem.surname}
      givenNames={$selectedItem.givenNames}
      affiliations={$selectedItem.affiliations}
      fields={$selectedItem.fields}
      ideas={$selectedItem.ideas}
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
</div>
