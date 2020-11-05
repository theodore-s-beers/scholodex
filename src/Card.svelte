<script lang="ts">
  import { fade } from "svelte/transition";
  import { cards } from "./stores.svelte";

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
</script>

<style>
  .card {
    background-color: #fafafa;
    display: flex;
    flex-flow: column nowrap;
    width: 300px;
    height: 132px;
    border: 1px solid rgba(16, 112, 64, 0.4);
    border-radius: 0.25rem;
    padding: 1rem;
    margin-top: 1rem;
    margin-left: 1rem;
  }
  .emailRow {
    display: flex;
    flex-flow: row nowrap;
  }
  .fieldLabel {
    min-width: 3.6rem;
    display: flex;
    align-items: center;
  }
  .fieldText {
    font-size: 90%;
  }
  .nameRow {
    display: flex;
    margin-bottom: 1rem;
  }
  .nameRow a {
    color: #404040;
  }
  .nameRow a:hover {
    text-decoration: none;
  }
  .names {
    font-size: 145%;
  }
  .normalRow {
    display: flex;
    flex-flow: row nowrap;
    margin-bottom: 0.8rem;
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
</style>

<div class="card" in:fade>
  <div class="nameRow">
    <div class="names">
      <a href={'#' + id}><span
          class="surname"><strong>{surname}</strong></span>{givenNames}</a>
    </div>
    <div class="xButtonWrapper">
      <button class="xButton" on:click={deleteCard}>✕</button>
    </div>
  </div>
  <div class="normalRow">
    <div class="fieldLabel"><em class="fieldText">affil.</em></div>
    <div>{primaryAffil}</div>
  </div>
  <div class="normalRow">
    <div class="fieldLabel"><em class="fieldText">field</em></div>
    <div>{primaryField}</div>
  </div>
  <div class="emailRow">
    <div class="fieldLabel"><em class="fieldText">email</em></div>
    <div><a href="mailto:{email}">{email}</a></div>
  </div>
</div>
