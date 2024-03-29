<script lang="ts">
  import { fade } from "svelte/transition";
  import { cards, current, editing, selectedItem } from "./stores.svelte";

  export let affiliations: string;
  export let email: string;
  export let fields: string;
  export let givenNames: string;
  export let id: string;
  export let ideas: string;
  export let index: number;
  export let surname: string;

  const affilArray = affiliations.toString().split(",");
  const fieldsArray = fields.toString().split(",");
  const ideasArray = ideas.toString().split(",");

  function backHome() {
    window.location.hash = "home";
  }

  function deleteCard() {
    $cards = $cards.slice(0, index).concat($cards.slice(index + 1));
    $selectedItem = {
      id: "",
      surname: "",
      givenNames: "",
      affiliations: "",
      fields: "",
      ideas: "",
      email: "",
    };
  }

  function fillGaps() {
    $current.id = id;
    $current.surname = surname;
    $current.givenNames = givenNames;
    $current.affiliations = affiliations;
    $current.fields = fields;
    $current.ideas = ideas;
    $current.email = email;
    $editing = true;
  }
</script>

<div class="card" in:fade>
  <div class="nameRow">
    <div class="names">
      <span class="surname"><strong>{surname}</strong></span>{givenNames}
    </div>
    <div class="xButtonWrapper">
      <button class="xButton" on:click={deleteCard}>✕</button>
    </div>
  </div>
  <div class="normalRow">
    <div class="fieldLabel" class:multi={affilArray.length > 1}>
      <em class="fieldText">affil.</em>
    </div>
    <div class="fieldContent">
      {#each affilArray as affiliation, index}
        {#if index !== affilArray.length - 1}
          <div>{affiliation}</div>
          <hr />
        {:else}
          <div>{affiliation}</div>
        {/if}
      {/each}
    </div>
  </div>
  <div>
    <hr />
  </div>
  <div class="normalRow">
    <div class="fieldLabel" class:multi={fieldsArray.length > 1}>
      <em class="fieldText">{fieldsArray.length > 1 ? "fields" : "field"}</em>
    </div>
    <div class="fieldContent">
      {#each fieldsArray as field, index}
        {#if index !== fieldsArray.length - 1}
          <div>{field}</div>
          <hr />
        {:else}
          <div>{field}</div>
        {/if}
      {/each}
    </div>
  </div>
  <div>
    <hr />
  </div>
  <div class="normalRow">
    <div class="fieldLabel" class:multi={ideasArray.length > 1}>
      <em class="fieldText">{ideasArray.length > 1 ? "ideas" : "idea"}</em>
    </div>
    <div class="fieldContent">
      {#each ideasArray as idea, index}
        {#if index !== ideasArray.length - 1}
          <div>{idea}</div>
          <hr />
        {:else}
          <div>{idea}</div>
        {/if}
      {/each}
    </div>
  </div>
  <div>
    <hr />
  </div>
  <div class="finalRow">
    <div class="fieldLabel"><em class="fieldText">email</em></div>
    <div class="fieldContent"><a href="mailto:{email}">{email}</a></div>
  </div>
  <div class="buttons">
    <div><button class="backButton" on:click={backHome}>Back</button></div>
    <div><button on:click={fillGaps}>Edit</button></div>
  </div>
</div>

<style>
  hr {
    border: 0;
    border-top: 1px solid rgba(0, 0, 0, 0.1);
    margin-bottom: 0.7rem;
  }
  .backButton {
    margin-right: 3rem;
  }
  .buttons {
    font-size: 90%;
    display: flex;
    flex-flow: row nowrap;
    justify-content: center;
    margin-top: auto;
  }
  .buttons button {
    padding: 0.4rem 0.5rem;
  }
  .card {
    width: 300px;
    min-height: 132px;
    border: 1px solid rgba(16, 112, 64, 0.4);
    border-radius: 0.25rem;
    padding: 1rem;
    display: flex;
    flex-flow: column nowrap;
    background-color: #fafafa;
  }
  .fieldContent {
    hyphens: auto;
  }
  .fieldContent hr {
    border-top: 1px solid rgba(16, 112, 64, 0.3);
    margin: 0.5rem 0 0.5rem;
    width: 180px;
  }
  .fieldLabel {
    min-width: 3.6rem;
    display: flex;
    align-items: center;
  }
  .fieldLabel.multi {
    align-items: stretch;
  }
  .fieldLabel,
  .fieldContent {
    line-height: 125%;
  }
  .fieldText {
    font-size: 90%;
  }
  .finalRow {
    display: flex;
    flex-flow: row nowrap;
    margin-bottom: 1.1rem;
  }
  .nameRow {
    display: flex;
    margin-bottom: 1.1rem;
  }
  .names {
    font-size: 145%;
  }
  .normalRow {
    display: flex;
    flex-flow: row nowrap;
    margin-bottom: 0.3rem;
  }
  .surname {
    margin-right: 0.7rem;
  }
  .xButton {
    height: 1.5rem;
    width: 1.5rem;
    font-size: 65%;
    padding-top: 1px;
  }
  .xButtonWrapper {
    margin-left: auto;
  }
  @media (min-width: 768px) {
    .card {
      margin: auto;
    }
  }
</style>
