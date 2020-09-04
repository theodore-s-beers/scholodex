<script lang="ts">
  import { fade } from "svelte/transition";
  import { cards, expanded, resultCards, selectedItem } from "./stores.svelte";

  export let affiliations: string;
  export let email: string;
  export let fields: string;
  export let givenNames: string;
  export let id: string;
  export let index: number;
  export let surname: string;

  const primaryAffil = affiliations.toString().split(",")[0];
  const primaryField = fields.toString().split(",")[0];

  function deleteCard() {
    $cards = $cards.slice(0, index).concat($cards.slice(index + 1));
  }

  function selectItem() {
    $selectedItem = $cards.find((x) => x.id === id);
    $expanded = false;
    $resultCards = [];
  }
</script>

<style>
  button {
    width: 1.5rem;
    height: 1.5rem;
  }
  .affilRow {
    margin-bottom: 0.5em;
    display: flex;
    flex-flow: row wrap;
  }
  .card {
    width: 300px;
    height: 150px;
    border: 1px solid #aaa;
    border-radius: 0.25em;
    box-shadow: 2px 2px 8px rgba(0, 0, 0, 0.1);
    padding: 1em;
    display: flex;
    flex-flow: column nowrap;
    margin-top: 1em;
    margin-left: 1em;
  }
  .emailRow {
    display: flex;
    flex-flow: row wrap;
  }
  .fieldLabel {
    width: 4em;
    font-size: 90%;
  }
  .fieldsRow {
    display: flex;
    flex-flow: row wrap;
    margin-bottom: 0.5em;
  }
  .moreButton {
    font-size: 45%;
    margin: auto 0 0 auto;
  }
  .nameRow {
    display: flex;
    font-size: 150%;
    margin-bottom: 0.5em;
  }
  .surname {
    margin-right: 0.5em;
  }
  .xButton {
    font-size: 45%;
    margin-left: auto;
  }
</style>

<div class="card" in:fade>
  <div class="nameRow">
    <div class="surname"><strong>{surname}</strong></div>
    <div>{givenNames}</div>
    <div class="xButton"><button on:click={deleteCard}>✕</button></div>
  </div>
  <div class="affilRow">
    <div class="fieldLabel"><em>affil.</em></div>
    <div>{primaryAffil}</div>
  </div>
  <div class="fieldsRow">
    <div class="fieldLabel"><em>field</em></div>
    <div>{primaryField}</div>
  </div>
  <div class="emailRow">
    <div class="fieldLabel"><em>email</em></div>
    <div><a href="mailto:{email}">{email}</a></div>
  </div>
  <div class="moreButton"><button on:click={selectItem}>→</button></div>
</div>
