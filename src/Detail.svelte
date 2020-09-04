<script lang="ts">
  import { fade } from "svelte/transition";
  import { cards, current, editing, selectedItem } from "./stores.svelte";

  export let affiliations: string;
  export let email: string;
  export let fields: string;
  export let givenNames: string;
  export let id: string;
  export let index: number;
  export let surname: string;

  const affilArray = affiliations.toString().split(",");
  const fieldsArray = fields.toString().split(",");

  function backHome() {
    $selectedItem = null;
    window.location.hash = "home";
  }

  function deleteCard() {
    $cards = $cards.slice(0, index).concat($cards.slice(index + 1));
    $selectedItem = null;
  }

  function fillGaps() {
    $current.id = id;
    $current.surname = surname;
    $current.givenNames = givenNames;
    $current.affiliations = affiliations;
    $current.fields = fields;
    $current.email = email;
    $editing = true;
  }
</script>

<style>
  .backButton {
    margin-right: 3em;
  }
  .buttons {
    display: flex;
    flex-flow: row nowrap;
    font-size: 90%;
    justify-content: center;
    margin-top: auto;
  }
  .card {
    width: 300px;
    min-height: 150px;
    border: 1px solid #aaa;
    border-radius: 0.25em;
    box-shadow: 2px 2px 8px rgba(0, 0, 0, 0.1);
    padding: 1em;
    display: flex;
    flex-flow: column nowrap;
    margin-left: auto;
    margin-right: auto;
  }
  .fieldLabel {
    width: 4em;
    font-size: 90%;
  }
  .finalRow {
    display: flex;
    flex-flow: row wrap;
    margin-bottom: 1em;
  }
  .nameRow {
    display: flex;
    font-size: x-large;
    margin-bottom: 0.5em;
  }
  .normalRow {
    display: flex;
    flex-flow: row wrap;
    margin-bottom: 0.5em;
  }
  .surname {
    margin-right: 0.5em;
  }
  .xButton {
    font-size: 45%;
    margin-left: auto;
  }
  .xButton button {
    width: 1.5rem;
    height: 1.5rem;
  }
</style>

<div class="card" in:fade>
  <div class="nameRow">
    <div class="surname"><strong>{surname}</strong></div>
    <div>{givenNames}</div>
    <div class="xButton"><button on:click={deleteCard}>✕</button></div>
  </div>
  <div class="normalRow">
    <div class="fieldLabel"><em>affil.</em></div>
    <div>
      {#each affilArray as affiliation}
        <div>{affiliation}</div>
      {/each}
    </div>
  </div>
  <div class="normalRow">
    <div class="fieldLabel">
      <em>{fields.length > 1 ? 'fields' : 'field'}</em>
    </div>
    <div>
      {#each fieldsArray as field}
        <div>{field}</div>
      {/each}
    </div>
  </div>
  <div class="finalRow">
    <div class="fieldLabel"><em>email</em></div>
    <div><a href="mailto:{email}">{email}</a></div>
  </div>
  <div class="buttons">
    <div><button class="backButton" on:click={backHome}>Back</button></div>
    <div><button on:click={fillGaps}>Edit</button></div>
  </div>
</div>
