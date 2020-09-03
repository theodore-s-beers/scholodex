<script lang="ts">
  import { fade } from "svelte/transition";
  import { cards, current, editing, selectedItem } from "./stores.svelte";
  import { complexCompare, sampleCards } from "./utils.svelte";

  import Card from "./Card.svelte";
  import Detail from "./Detail.svelte";
  import Editor from "./Editor.svelte";

  try {
    $cards = JSON.parse(localStorage.getItem("scholodex-cards")) || [];
  } catch (err) {
    $cards = [];
  }

  function newCard() {
    $current = {
      id: "",
      surname: "",
      givenNames: "",
      affiliations: "",
      fields: "",
      email: "",
    };
    $selectedItem = null;
    $editing = true;
  }

  function loadSample() {
    if ($cards.length === 0) {
      $cards = sampleCards;
    } else {
      return;
    }
  }

  loadSample();

  $: cardsBySurname = $cards.sort(complexCompare);

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
  .newCardButton {
    margin-right: 1em;
  }
  .title {
    font-size: 200%;
    line-height: 105%;
    margin-right: 0.6em;
    color: darkgreen;
  }
</style>

<svelte:head>
  <link
    href="https://fonts.googleapis.com/css2?family=Lora:ital@0;1&display=swap"
    rel="stylesheet" />
</svelte:head>

<header>
  <div class="title">Scholodex</div>
  <div class="newCardButton">
    <button on:click={newCard} disabled={$selectedItem || $editing}>New</button>
  </div>
  <div>
    <button
      on:click={loadSample}
      disabled={$cards.length > 0 || $editing}>Sample</button>
  </div>
</header>

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
      {#each cardsBySurname as card, index (card.id)}
        <Card
          {index}
          id={card.id}
          surname={card.surname}
          givenNames={card.givenNames}
          affiliations={card.affiliations}
          fields={card.fields}
          email={card.email} />
      {/each}
    </div>
  {/if}
</main>
